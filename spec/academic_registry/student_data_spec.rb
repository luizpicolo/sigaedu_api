RSpec.describe SigaeduApi::AcademicRegistry::StudentData do
  let(:mechanize) { instance_double(Mechanize) }
  let(:api) { instance_double(SigaeduApi::Api, mechanize: mechanize) }
  let(:page) do
    instance_double("Page", body: <<~HTML)
      <table class="table"><tbody><tr><td>ignored</td><td>2024.2-A</td></tr></tbody></table>
    HTML
  end

  before do
    allow(SigaeduApi::Api).to receive(:new).and_return(api)
    allow(api).to receive(:form)
    allow(mechanize).to receive(:get).and_return(page)
  end

  it "returns the student's class and requests the canonical endpoint" do
    data = described_class.new("user", "secret").get_data("123")
    expect(data).to eq([{ id_estudante: "123", turma: "2024.2-A" }])
    expect(mechanize).to have_received(:get).with(
      "https://academico.ifms.edu.br/administrativo/alunos/ficha_estudante/123/dados_academicos"
    )
  end

  it "does not retain records between calls" do
    student_data = described_class.new("user", "secret")
    expect(student_data.get_data("123")).to have_attributes(size: 1)
    expect(student_data.get_data("124")).to have_attributes(size: 1)
  end

  it "authenticates with the credentials supplied at initialization" do
    described_class.new("user", "secret")

    expect(api).to have_received(:form).with("user", "secret")
  end

  it "reads cells only from the academic data table" do
    page_with_other_table = instance_double("Page", body: <<~HTML)
      <table><tbody><tr><td>other data</td></tr></tbody></table>
      <table class="table"><tbody><tr><td>ignored</td><td>2025.1-B</td></tr></tbody></table>
    HTML
    student_data = described_class.new("user", "secret")

    expect(student_data.attribute_by_position(page_with_other_table, 1)).to eq("2025.1-B")
  end
end
