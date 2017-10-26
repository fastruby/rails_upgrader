require "rails"
require "rails_erd"
require "rails_erd/domain"
require "active_model/naming"

module RailsUpgrader
  class CLI
    attr_reader :domain

    def self.call
      new.upgrade
    end

    def initialize
      puts "Preloading environment..."
      preload_environment
      puts "Preloading relationships..."
      @domain = RailsERD::Domain.generate
    end

    def upgrade
      puts "Upgrading Rails..."
      upgrade_strong_params!
      puts "Rails is upgraded!"
    end

    private

    def upgrade_strong_params
      result = domain.entities.map do |entity|
        RailsUpgrader::StrongParams.generate_for(entity) if entity.model
      end.join

      File.open("strong_params.rb", "w") { |f| f.write(result) }
    end

    def upgrade_strong_params!
      domain.entities.each do |entity|
        if entity.model
          strong_params = RailsUpgrader::StrongParams.generate_for(entity)

          param_key = ActiveModel::Naming.param_key(entity.model)
          controller_path = "app/controllers/#{param_key}s_controller.rb"

          unless File.file?(controller_path)
            puts "Skipping #{entity.name}"
            next
          end

          controller_content = File.read(controller_path)
          next if controller_content.include?("def #{param_key}_params")

          last_end = controller_content.rindex("end")
          controller_content[last_end..last_end+3] = "\n#{strong_params}end\n"
          begin
            File.open(controller_path, 'wb') do |file|
              file.write(controller_content)
            end
          rescue => e
            puts e.message
            puts e.backtrace
            next
          end
        end
      end
    end

    def preload_environment
      require "#{Dir.pwd}/config/environment"
      Rails.application.eager_load!

      if Rails.application.respond_to?(:config) && Rails.application.config
        rails_config = Rails.application.config
        if rails_config.respond_to?(:eager_load_namespaces)
          rails_config.eager_load_namespaces.each(&:eager_load!)
        end
      end
    end
  end
end
