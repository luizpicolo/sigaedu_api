require "sigaedu_api/api"
require "open-uri"

module SigaeduApi
  module AcademicRegistry
    class Course
      def initialize(login, password)
        @uri = 'https://academico.ifms.edu.br/administrativo/alunos/panorama'
        @login = login
        @password = password
        @api = Api.new
        @api.form(login, password)
      end

      def get_data
        array = []
        page = @api.mechanize.get(@uri)
        data = page.body.scan(/<option value="([1-9]+)">(\D+)<\/option>/)
        data.each do |d|
          course = d.last.force_encoding('UTF-8')
          new_data = course.scan(/;([^>]*) -([^>]*)/).first
          array << {
            'id': d[0], 
            'curso': new_data[0].strip, 
            'tipo_oferta': new_data[1].strip
          }
        end

        array
      end
    end
  end
end
