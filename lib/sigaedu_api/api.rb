module SigaeduApi
  class Api
    BASE_URL = "https://academico.ifms.edu.br/administrativo/".freeze

    def initialize(mechanize: Mechanize.new)
      @mechanize = mechanize
      @mechanize.get(BASE_URL)
    end

    attr_reader :mechanize

    def form(login, password)
      form = @mechanize.page.forms.first
      raise "Login form not found" unless form

      form.field_with(name: "data[Usuario][login]").value = login
      form.field_with(name: "data[Usuario][senha]").value = password
      form.method = "POST"
      form.submit
    end
  end
end
