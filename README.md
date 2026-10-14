# SigaeduApi

Cliente Ruby para consultar dados acadêmicos do SIGA Edu do IFMS.

## Requisitos

- Ruby 4.0 ou superior

## Instalação

Adicione a gem ao `Gemfile` da aplicação:

```ruby
gem "sigaedu_api"
```

Em seguida, execute `bundle install`.

## Uso

```ruby
require "sigaedu_api"

courses = SigaeduApi::AcademicRegistry::Course.new(login, password)
courses.get_data("Campo Grande")

students = SigaeduApi::AcademicRegistry::Student.new(login, password)
students.get_data("Campo Grande")

student_data = SigaeduApi::AcademicRegistry::StudentData.new(login, password)
student_data.get_data(student_id)
```

As credenciais são usadas somente para autenticar a sessão no SIGA Edu. Os testes automatizados não acessam o sistema acadêmico.

## TLS do SIGA Edu

O SIGA Edu atualmente não entrega toda a cadeia de certificados necessária para alguns ambientes Ruby. A gem inclui os certificados públicos RNP ICPEdu GR46 e GlobalSign Root R46 para completar essa cadeia, mantendo a verificação TLS e de hostname ativas.

## Desenvolvimento

Depois de clonar o repositório, instale as dependências com `bundle install` e rode a suíte com:

```sh
bundle exec rake spec
```

O CI executa os specs em Ruby 4.0 e instala Rails 8.1 como dependência de desenvolvimento para validar a compatibilidade da gem.

## Licença

Distribuída sob a licença MIT. Consulte [LICENSE.txt](LICENSE.txt).
