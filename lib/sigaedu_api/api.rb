require "openssl"

module SigaeduApi
  class Api
    BASE_URL = "https://academico.ifms.edu.br/administrativo/".freeze
    RNP_INTERMEDIATE_CERTIFICATE = File.expand_path("certificates/rnp_icpedu_gr46_ov_tls_ca_2025.pem", __dir__).freeze
    GLOBALSIGN_ROOT_CERTIFICATE = File.expand_path("certificates/globalsign_root_r46.pem", __dir__).freeze

    def self.default_cert_store
      OpenSSL::X509::Store.new.tap do |store|
        store.set_default_paths
        store.add_file(RNP_INTERMEDIATE_CERTIFICATE)
        store.add_file(GLOBALSIGN_ROOT_CERTIFICATE)
      end
    end

    def initialize(mechanize: Mechanize.new, cert_store: self.class.default_cert_store)
      @mechanize = mechanize
      @mechanize.agent.http.cert_store = cert_store
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
