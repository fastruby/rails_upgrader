require "spec_helper"

RSpec.describe RailsUpgrader do
  describe "#call" do
    let(:dummy_path) do
      File.join(File.dirname(__FILE__), "dummy")
    end
    let(:model) do
      File.join(dummy_path, "app", "models", "user.rb")
    end
    let(:controller) do
      File.join(dummy_path, "app", "controllers", "users_controller.rb")
    end
    let(:env_variables) { "BUNDLE_GEMFILE=Gemfile RAILS_ENV=test" }

    before { reset_dummy_files }
    after { reset_dummy_files }

    it "migrates controller from using protected attributes to strong params" do
      system("cd #{dummy_path} && #{env_variables} rails_upgrader")

      strong_parameters = <<-END
  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :project_id)
  end
      END
      accessible_attributes = "attr_accessible :first_name, :last_name, :project_id"

      expect(File.read(controller)).to include strong_parameters
      expect(File.read(model)).not_to include accessible_attributes
    end
  end
end
