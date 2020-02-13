require 'sigaedu_api/api'
require 'sigaedu_api/academic_registry/course'

module SigaeduApi
  module AcademicRegistry
    class StudentData
      def initialize(login, password)
        @uri = 'https://academico.ifms.edu.br/administrativo/alunos/ficha_estudante/'
        @login = login
        @student_data = []
        @password = password
        @api = Api.new
        @api.form(login, password)
      end

      def attribute_by_position(data, i)
        doc = Nokogiri::HTML(data.body)
        doc.css('table.table tbody td')[i].text
      end

      def get_data(student_id = nil)
        uri = "#{@uri}/#{student_id}/dados_academicos"
        page = @api.mechanize.get(uri)
        attribute_by_position(page, 1)
        
        @student_data << {
          'id': student_id,
          'turma': attribute_by_position(page, 1)
        }

        @student_data
      end    
    end
  end
end
