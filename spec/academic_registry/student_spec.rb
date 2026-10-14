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

  it "extracts a name, identifier, and photo URL from a student row" do
    student = described_class.new("user", "secret")

    expect(student.get_name(student_row, 8)).to eq("Ana Silva")
    expect(student.get_id(student_row, 8)).to eq("123")
    expect(student.get_image(student_row)).to end_with("/456")
  end

  it "does not request student data when no courses are available" do
    allow(SigaeduApi::AcademicRegistry::Course).to receive(:new).and_return(instance_double("Course", get_data: []))

    expect(described_class.new("user", "secret").get_data("Campo Grande")).to eq([])
    expect(mechanize).not_to have_received(:get)
  end

  it "skips rows without an enrollment date" do
    empty_row = Array.new(14, "")
    allow(mechanize).to receive(:get).and_return(instance_double("Page", body: { aaData: [empty_row] }.to_json))

    expect(described_class.new("user", "secret").get_data).to eq([])
  end

  it "uses the course identifier in the student endpoint" do
    described_class.new("user", "secret").get_data

    expect(mechanize).to have_received(:get).with(
      "https://academico.ifms.edu.br/administrativo/alunos/panorama/datatable_lista_estudante_por_campus/10"
    )
  end
end
