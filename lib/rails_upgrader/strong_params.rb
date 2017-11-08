require "active_model/naming"

module RailsUpgrader
  class StrongParams
    attr_reader :entity, :param_key, :controller_path, :model_path
    ATTR_ACCESSIBLE_REGEX = /\s+attr_accessible\s+([:]\w+[,]?\s+)+/.freeze

    def initialize(entity)
      @entity = entity
      @param_key = ActiveModel::Naming.param_key(entity.model)
      @controller_path = "app/controllers/#{param_key}s_controller.rb"
      @model_path = "app/models/#{param_key}.rb"
    end

    def already_upgraded?
      controller_content.include?("def #{param_key}_params")
    end

    def update_controller_content!
      updated_content = append_strong_params

      File.open(controller_path, 'wb') do |file|
        file.write(updated_content)
      end
    end

    def update_model_content!
      updated_content = removed_attr_accessible

      File.open(model_path, 'wb') do |file|
        file.write(updated_content)
      end
    end

    private

      def append_strong_params
        last_end = controller_content.rindex("end")
        controller_content[last_end..last_end+3] = "\n#{generate_method}end\n"
      end

      def controller_content
        File.read(controller_path)
      end

      def model_content
        File.read(model_path)
      end

      def generate_method
        result = "  def #{param_key}_params\n"
        result += "    params.require(:#{param_key})\n"

        param_list = entity.attributes.reject do |attribute|
          attribute.to_s =~ /^id$|^type$|^created_at$|^updated_at$|_token$|_count$/
        end.map { |attribute| ":#{attribute}" }.join(", ")
        result += "          .permit(#{param_list})\n"

        if entity.model.nested_attributes_options.present?
          result += "  # TODO: check nested attributes for: #{entity.model.nested_attributes_options.keys.join(', ')}\n"
        end
        result += "  end\n\n"
        result
      end

      def removed_attr_accessible
        result = model_content
        result[/\s+attr_accessible\s+([:]\w+[,]?\s+)+/] = "\n"
        result
      end
  end
end
