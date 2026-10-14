RSpec.describe SigaeduApi::Api do
  let(:login_field) { instance_double("Mechanize::Form::Field", value: nil) }
  let(:password_field) { instance_double("Mechanize::Form::Field", value: nil) }
  let(:form) { instance_double("Mechanize::Form") }
  let(:page) { instance_double("Mechanize::Page", forms: [form]) }
  let(:http) { instance_double("Net::HTTP::Persistent") }
  let(:agent) { instance_double("Mechanize::HTTP::Agent", http: http) }
  let(:mechanize) { instance_double(Mechanize, page: page, agent: agent) }

  before do
    allow(mechanize).to receive(:get)
    allow(http).to receive(:cert_store=)
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

  it "adds the current RNP intermediate certificate without disabling TLS verification" do
    described_class.new(mechanize: mechanize)

    expect(http).to have_received(:cert_store=).with(be_a(OpenSSL::X509::Store))
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

  it "exposes the supplied client for authenticated requests" do
    api = described_class.new(mechanize: mechanize)

    expect(api.mechanize).to be(mechanize)
  end
end
