Gem::Specification.new do |spec|
  spec.name = 'bbservices'
  spec.version = '2.1.0'
  spec.authors = 'Stuart Farnaby, Big Bear Studios'
  spec.license = 'MIT'
  spec.homepage = 'https://gitlab.com/big-bear-studios-open-source/bbservices'
  spec.summary = 'A simple service library for Ruby. Please see BBActiveRecordServices for a Rails / AR service library'

  spec.files = ['lib/bbservices.rb']
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '3.9.0'
  spec.add_development_dependency 'rubocop', '0.86.0'
  spec.add_development_dependency 'simplecov', '0.18.5'
end