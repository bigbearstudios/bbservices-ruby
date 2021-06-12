# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'bbservices'
  spec.version = '3.1.1'
  spec.authors = 'Stuart Farnaby, Big Bear Studios'
  spec.license = 'MIT'
  spec.homepage = 'https://gitlab.com/big-bear-studios-open-source/bbservices'
  spec.summary = 'A simple service library for Ruby. Please see BBActiveRecordServices for a Rails / AR service library'

  spec.required_ruby_version = '>= 2.5'

  spec.files = ['lib/bbservices.rb']
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'guard-rspec', '4.7.3'
  spec.add_development_dependency 'rspec', '3.9.0'
  spec.add_development_dependency 'rubocop', '1.13'
  spec.add_development_dependency 'simplecov', '0.18.5'
  spec.add_development_dependency 'yard', '~> 0.8.7.6'
end
