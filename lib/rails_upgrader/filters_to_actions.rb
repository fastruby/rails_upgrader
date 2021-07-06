module RailsUpgrader
  class FiltersToActions
    attr_accessor :controllers, :dry_run_file

    def initialize
      @controllers = ApplicationController.descendants
      @dry_run_file = []
      update_controllers
    end

    def update_controllers
      @controllers.each do |controller|
        controller_path=("app/controllers/#{controller.name.underscore}.rb")
        text = File.read(controller_path)
        text.gsub!(/_filter/, "_action") unless text.match(/_action/)
        File.write(controller_path, text)
        @dry_run_file.push("==== dry run preview: #{controller} ====" + "\n" + text)
      end
    end
  end
end
