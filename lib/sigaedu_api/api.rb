class Api
  def initialize
    @mechanize = Mechanize.new
    @mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @mechanize.get("https://academico.ifms.edu.br/administrativo/")
  end

  def mechanize
    @mechanize
  end

  def form(login, password)
    f = @mechanize.page.forms.first
    f.field_with(name: "data[Usuario][login]").value = login
    f.field_with(name: "data[Usuario][senha]").value = password
    f.method = "POST"
    f.submit
  end
end
