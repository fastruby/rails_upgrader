require "active_model/naming"

module RailsUpgrader
  class FilterMethods
    attr_reader :entity, :param_key, :controller_path, :model_path
    ATTR_ACCESSIBLES = /\s+attr_accessible\s+([:]\w+[,]?\s+)+/.freeze

    def initialize(entity)
      @entity = entity
      @param_key = ActiveModel::Naming.param_key(entity.model)
      @controller_path = "app/controllers/#{param_key}s_controller.rb"
    end

    def update_controller_content!
      updated_content = replace_file_to_action

      File.open(controller_path, 'wb') do |file|
        file.write(updated_content)
      end
    end

    def replace_file_to_action
      controller_content
        .sub("before_filter", "before_action")
        .sub("after_filter", "after_action")
        .sub("skip_before_filter", "skip_before_action")
    end

    def already_upgraded?
      controller_content.include?(/^[A-Za-z]+_filter/)
    end

    private
    def controller_content
      File.read(controller_path)
    end
  end
end

