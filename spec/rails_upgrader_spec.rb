require "spec_helper"

RSpec.describe RailsUpgrader do
  it "has a version number" do
    expect(RailsUpgrader::VERSION).not_to be nil
  end
end
