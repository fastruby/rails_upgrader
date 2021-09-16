require "rails"
require "rails_erd"
require "rails_erd/domain"

module RailsUpgrader
  class CLI
    attr_reader :domain

    def self.call
      new.upgrade
    end

    def initialize
      preload_environment
      puts "Preloading relationships..."
      @domain = RailsERD::Domain.generate
    end

    def upgrade
      puts "Upgrading Rails..."
      upgrade_strong_params!
      upgrade_filter_methods!
      puts "Rails is upgraded!"
    end

    private

    def upgrade_filter_methods
      result = domain.entities.map do |entity|
        RailsUpgrader::StrongParams.new(entity).generate_method if entity.controller
      end.join

      if write_to_file
        filename = "all_filter_methods.rb"
        File.open(filename, "w") { |f| f.write(result) }
        puts "See the strong params result at generated file: #{filename}"
      else
        puts "\n\n==== ALL FILTER METHODS: ====="
        puts result
        puts "============================="
      end
    end

    def upgrade_filter_methods!
      domain.entities.each do |entity|
        if entity.controller
          entity_to_upgrade = RailsUpgrader::FilterMethods.new(entity)

          next if entity_to_upgrade.already_upgraded?

          begin
            entity_to_upgrade.update_controller_content!
          rescue => e
            puts e.message
            puts e.backtrace
            next
          end
        end
      end
    end

    def upgrade_strong_params(write_to_file)
      result = domain.entities.map do |entity|
        RailsUpgrader::StrongParams.new(entity).generate_method if entity.model
      end.join

      if write_to_file
        filename = "all_strong_params.rb"
        File.open(filename, "w") { |f| f.write(result) }
        puts "See the strong params result at generated file: #{filename}"
      else
        puts "\n\n==== ALL STRONG PARAMS: ====="
        puts result
        puts "============================="
      end
    end

    def upgrade_strong_params!
      domain.entities.each do |entity|
        next unless entity.model
        entity_to_upgrade = RailsUpgrader::StrongParams.new(entity)

        unless File.file?(entity_to_upgrade.controller_path)
          puts "Skipping #{entity.name}"
          next
        end

        next if entity_to_upgrade.already_upgraded?

        begin
          entity_to_upgrade.update_controller_content!
          entity_to_upgrade.update_model_content!
        rescue => e
          puts e.message
          puts e.backtrace
          next
        end
      end
    end

    def preload_environment
      begin
        require "#{Dir.pwd}/config/environment"
      rescue LoadError => e
        puts "Rails application not found! If you're on "\
             "a Rails application, please open a Github issue: "\
             "https://github.com/ombulabs/rails_upgrader/issues"
        abort
      end

      puts "Preloading environment..."
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
