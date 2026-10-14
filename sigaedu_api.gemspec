
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sigaedu_api/version"

Gem::Specification.new do |spec|
  spec.name          = "sigaedu_api"
  spec.version       = SigaeduApi::VERSION
  spec.authors       = ["Luiz Picolo"]
  spec.email         = ["luizpicolo@gmail.com"]

  spec.summary       = "SigaEdu API"
  spec.description   = "Gem para gerar uma API com o objetivo de consumir dados do sistemas acadêmico do IFMS"
  spec.homepage      = "https://github.com/luizpicolo/sigaedu_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match?(%r{^(test|spec|features)/}) || !File.file?(f)
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 4.0"

  spec.add_dependency "json", ">= 2.6", "< 3.0"
  spec.add_dependency "mechanize", ">= 2.9", "< 3.0"
  spec.add_dependency "nokogiri", ">= 1.15", "< 2.0"

  spec.add_development_dependency "bundler", ">= 4.0", "< 5.0"
  spec.add_development_dependency "rake", ">= 13.0", "< 14.0"
  spec.add_development_dependency "rails", "~> 8.1.4"
  spec.add_development_dependency "rspec", "~> 3.13"
end
