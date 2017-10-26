require "spec_helper"
require "rails_upgrader/cli"
require "pry"

RSpec.describe RailsUpgrader::CLI do
  subject { described_class }

  describe "#call" do
    let(:dummy_path) do
      File.join(File.dirname(__FILE__), "..", "dummy")
    end
    let(:model) do
      File.join(dummy_path, "app", "models", "user.rb")
    end
    let(:controller) do
      File.join(dummy_path, "app", "controllers", "users_controller.rb")
    end

    it "converts models from using protected attributes to strong params" do
      system("cd #{dummy_path}; RAILS_ENV=test rails_upgrader")
    end
  end
end
