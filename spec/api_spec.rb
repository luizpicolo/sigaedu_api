RSpec.describe SigaeduApi::Api do
  let(:login_field) { instance_double("Mechanize::Form::Field", value: nil) }
  let(:password_field) { instance_double("Mechanize::Form::Field", value: nil) }
  let(:form) { instance_double("Mechanize::Form") }
  let(:page) { instance_double("Mechanize::Page", forms: [form]) }
  let(:mechanize) { instance_double(Mechanize, page: page) }

  before do
    allow(mechanize).to receive(:get)
    allow(login_field).to receive(:value=)
    allow(password_field).to receive(:value=)
    allow(form).to receive(:field_with).with(name: "data[Usuario][login]").and_return(login_field)
    allow(form).to receive(:field_with).with(name: "data[Usuario][senha]").and_return(password_field)
    allow(form).to receive(:method=)
    allow(form).to receive(:submit)
  end

  it "opens the academic system using the supplied client" do
    described_class.new(mechanize: mechanize)
    expect(mechanize).to have_received(:get).with(described_class::BASE_URL)
  end

  it "submits the login form" do
    api = described_class.new(mechanize: mechanize)
    api.form("user", "secret")

    expect(login_field).to have_received(:value=).with("user")
    expect(password_field).to have_received(:value=).with("secret")
    expect(form).to have_received(:method=).with("POST")
    expect(form).to have_received(:submit)
  end

  it "raises a useful error when the login form is absent" do
    allow(page).to receive(:forms).and_return([])
    api = described_class.new(mechanize: mechanize)
    expect { api.form("user", "secret") }.to raise_error("Login form not found")
  end
end
