# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capitalone-api/version'

Gem::Specification.new do |spec|
  spec.name          = 'capitalone-api'
  spec.version       = CapitalOneAPI::VERSION
  spec.authors       = ['Alexey Shepelev (RewardExpert)']
  spec.email         = ['al.shepelev@gmail.com']

  spec.summary       = %q{Wrapper for CapitalOne API}
  spec.description   = %q{Wrapper for CapitalOne API}
  spec.homepage      = 'https://github.com/AlexeyShepelev/capitalone-api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject{ |f| f.match(%r{^(\.|(test|spec|features)/)}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}){ |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'multi_json', '~> 1.11'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
