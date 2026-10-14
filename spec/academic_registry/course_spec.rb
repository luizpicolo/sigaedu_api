RSpec.describe SigaeduApi::AcademicRegistry::Course do
  let(:mechanize) { instance_double(Mechanize) }
  let(:api) { instance_double(SigaeduApi::Api, mechanize: mechanize) }
  let(:body) do
    <<~HTML
      <option value="10">Campo Grande &gt; Tecnologia em Sistemas para Internet - Superior</option>
      <option value="11">Dourados &gt; Técnico em Informática - Técnico</option>
      <option value="">Selecione</option>
    HTML
  end

  before do
    allow(SigaeduApi::Api).to receive(:new).and_return(api)
    allow(api).to receive(:form)
    allow(mechanize).to receive(:get).and_return(instance_double("Page", body: body))
  end

  it "returns the courses belonging to the requested campus" do
    courses = described_class.new("user", "secret").get_data("Campo Grande")
    expect(courses).to eq([{ id: "10", curso: "Tecnologia em Sistemas para Internet", tipo_oferta: "Superior" }])
  end

  it "returns all valid courses when no campus is provided" do
    courses = described_class.new("user", "secret").get_data
    expect(courses.map { |course| course[:id] }).to eq(%w[10 11])
  end
end
