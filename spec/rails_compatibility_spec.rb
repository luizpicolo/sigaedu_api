require "rails"

RSpec.describe "Rails compatibility" do
  it "loads the supported Rails release" do
    expect(Gem::Version.new(Rails.version)).to be >= Gem::Version.new("8.1.4")
    expect(Gem::Version.new(Rails.version)).to be < Gem::Version.new("8.2.0")
  end
end
