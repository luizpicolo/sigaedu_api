RSpec.describe SigaeduApi::AcademicRegistry::Student do
  let(:mechanize) { instance_double(Mechanize) }
  let(:api) { instance_double(SigaeduApi::Api, mechanize: mechanize) }
  let(:course) { { id: "10" } }
  let(:student_row) do
    ["2024", "Sistemas", "Campo Grande", "Centro", "Superior", "Noturno", "2024001", "456",
     '<a href="/administrativo/pessoa_fisicas/123">Ana Silva</a>', "123.456.789-00", "2000-01-01", nil,
     "(67) 99999-9999", "Ativo"]
  end

  before do
    allow(SigaeduApi::Api).to receive(:new).and_return(api)
    allow(api).to receive(:form)
    allow(SigaeduApi::AcademicRegistry::Course).to receive(:new).and_return(instance_double("Course", get_data: [course]))
    allow(mechanize).to receive(:get).and_return(instance_double("Page", body: { aaData: [student_row] }.to_json))
  end

  it "maps a student row to stable API attributes" do
    students = described_class.new("user", "secret").get_data("Campo Grande")

    expect(students).to contain_exactly(include(
      id: "123", estudante: "Ana Silva", identificador_curso: "10", ra: 456,
      foto: "https://academico.ifms.edu.br/administrativo/pessoa_fisicas/foto/456"
    ))
  end

  it "does not retain students between calls" do
    student = described_class.new("user", "secret")
    expect(student.get_data).to have_attributes(size: 1)
    expect(student.get_data).to have_attributes(size: 1)
  end

  it "uses empty strings for absent values" do
    student = described_class.new("user", "secret")
    expect(student.attribute_by_position(nil, 1)).to eq("")
    expect(student.get_name(nil, 8)).to eq("")
    expect(student.get_id(nil, 8)).to eq("")
  end
end
