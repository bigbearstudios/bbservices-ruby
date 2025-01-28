# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'bbservices'
  spec.version = '4.0.0'
  spec.authors = 'Stuart Farnaby, Big Bear Studios'
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/bigbearstudios/bbservices-ruby'
  spec.summary = 'A simple service library for Ruby. Allows the usage of Services through a set of simple to use classes'

  spec.required_ruby_version = '>= 3.2.0'

  spec.files = ['lib/bbservices.rb']
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '3.4.0'
  spec.add_development_dependency 'simplecov', '0.22.0'
end
