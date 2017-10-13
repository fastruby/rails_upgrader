require "rails"
require "rails_erd"
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
          result = RailsUpgrader::StrongParams.generate_for(entity)

          param_key = ActiveModel::Naming.param_key(entity.model)
          model_path = "app/models/#{param_key}.rb"

          unless File.file?(model_path)
            puts "Skipping #{entity.name}"
            next
          end

          model_content = File.read(model_path)
          next if model_content.include?("def #{param_key}_params")

          last_end = model_content.rindex("end")
          model_content[last_end..last_end+3] = "\n#{result}end\n"

          begin
            File.open(model_path, 'wb') { |file| file.write(model_content) }
          rescue => e
            puts e.message
            puts e.backtrace
            next
          end
        end
      end
    end

    def preload_environment
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
