require "sigaedu_api/api"
require "open-uri"

module SigaeduApi
  module AcademicRegistry
    class Course
      def initialize(login, password)
        @uri = 'https://academico.ifms.edu.br/administrativo/alunos/panorama'
        @login = login
        @password = password
        @api = SigaeduApi::Api.new
        @api.form(login, password)
      end

      def get_data(campus = nil)
        array = []
        page = @api.mechanize.get(@uri)
        page.body.scan(/<option value="(\d+)">(.*?)<\/option>/m).each do |id, option|
          campus_name, course_details = option.force_encoding("UTF-8").split("&gt;", 2)
          next if campus && campus_name&.strip != campus

          course_name, offer_type = course_details.to_s.split(";", 2).last.to_s.split(" - ", 2)
          next if course_name.empty? || offer_type.nil?

          array << {
            id: id,
            curso: course_name.strip,
            tipo_oferta: offer_type.strip
          }
        end

        array
      end
    end
  end
end
