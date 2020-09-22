require "spec_helper"

RSpec.describe RailsUpgrader do
  let(:dummy_path) do
    File.join(File.dirname(__FILE__), "dummy")
  end

  let(:gemfile) { File.expand_path("../dummy/Gemfile", __FILE__) }
  let(:env_variables) { "BUNDLE_GEMFILE=#{gemfile} RAILS_ENV=test" }

  let(:strong_parameters) do
    <<-END
  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :project_id)
  end
      END
  end

  describe "#go" do
    let(:model) do
      File.join(dummy_path, "app", "models", "user.rb")
    end
    let(:controller) do
      File.join(dummy_path, "app", "controllers", "users_controller.rb")
    end

    before { reset_dummy_files }
    after { reset_dummy_files }

    it "migrates controller from using protected attributes to strong params" do
      system("cd #{dummy_path} && #{env_variables} bundle exec rails_upgrader go")

      accessible_attributes = "attr_accessible :first_name, :last_name, :project_id"

      expect(File.read(controller)).to include strong_parameters
      expect(File.read(controller)).to include "class UsersController < ApplicationController"
      expect(File.read(model)).not_to include accessible_attributes
      expect(File.read(model)).to include "class User < ActiveRecord::Base"
    end

    xit "migrates with nested attributes" do
      # future test case
    end

    xit "writes to file instead of upgrading files in place" do
      # future test case, move to RailsUpgrader::CLI
    end

    xit "skips the controller if already upgraded" do
      # future test case, move to RailsUpgrader::CLI
    end
  end

  describe "#dry-run" do
    let(:strong_params_file) { File.join(dummy_path, "all_strong_params.rb") }

    let(:upgrade_command) do
      "cd #{dummy_path} && #{env_variables} bundle exec rails_upgrader dry-run"
    end

    before do
      File.delete(strong_params_file) if File.exist?(strong_params_file)
    end

    context "without extra params" do
      it "do not save the params to a file" do
        system(upgrade_command)
        expect { expect(strong_params_file).to_not be_an_existing_file }
      end

      it "output the result at console" do
        expect { system(upgrade_command) }.to output(/#{Regexp.quote(strong_parameters)}/).to_stdout_from_any_process
      end
    end

    context "with the param --file" do
      before do
        system("#{upgrade_command} --file")
      end

      it "write strong parameters migrations to a file" do
        expect { expect(strong_params_file).to be_an_existing_file }
        expect(File.read(strong_params_file)).to include strong_parameters
      end
    end
  end
end
