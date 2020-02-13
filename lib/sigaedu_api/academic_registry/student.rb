require 'sigaedu_api/api'
require 'sigaedu_api/academic_registry/course'

module SigaeduApi
  module AcademicRegistry
    class Student
      def initialize(login, password)
        @uri = 'https://academico.ifms.edu.br/administrativo/alunos/panorama'
        @students = []
        @login = login
        @password = password
        @api = Api.new
        @api.form(login, password)
      end

      def attribute_by_position(data, i)
        !data.nil? ? data[i] : ''
      end

      def get_name(data, i)
        !data.nil? ? attribute_by_position(data, i).scan(/>([^>]*)</)[0][0] : ''
      end

      def get_image(data)
        "https://academico.ifms.edu.br/administrativo/pessoa_fisicas/foto/#{attribute_by_position(data, 7).to_i}"
      end

      def get_data(campus = nil)
        courses = SigaeduApi::AcademicRegistry::Course.new(@login, @password)
        courses.get_data(campus).each do |course|
          uri = "#{@uri}/datatable_lista_estudante_por_campus/#{course[:id]}"
          page = @api.mechanize.get(uri)
          _data = JSON.parse(page.body)['aaData']
          _data.each do |data|
            if attribute_by_position(data, 0) != ""
              @students << {
                'ingresso': attribute_by_position(data, 0),
                'curso': attribute_by_position(data, 1) ,
                'identificador_curso': course[:id],
                'campus': attribute_by_position(data, 2),
                'polo': attribute_by_position(data, 3),
                'tipo_oferta': attribute_by_position(data, 4),
                'turno': attribute_by_position(data, 5),
                'matricula': attribute_by_position(data, 6),
                'ra': attribute_by_position(data, 7).to_i,
                'estudante': get_name(data, 8),
                'foto': get_image(data),
                'cpf': attribute_by_position(data, 9),
                'data_de_nascimento': attribute_by_position(data, 10),
                'telefone': attribute_by_position(data, 12),
                'situacao_no_curso': attribute_by_position(data, 13)
              }
            end
          end
        end

        @students
      end
    end
  end
end
