require "active_model/naming"

module RailsUpgrader
  class StrongParams
    def self.generate_for(entity)
      param_key = ActiveModel::Naming.param_key(entity.model)

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
  end
end
