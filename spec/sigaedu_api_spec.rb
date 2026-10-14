RSpec.describe SigaeduApi do
  it "has a version number" do
    expect(SigaeduApi::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
