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

    before { reset_controller_content }

    it "migrates controller from using protected attributes to strong params" do
      system("cd #{dummy_path} && BUNDLE_GEMFILE=Gemfile RAILS_ENV=test rails_upgrader")

      # expect()
    end
  end
end
