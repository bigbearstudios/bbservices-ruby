Gem::Specification.new do |s|
  s.name = %q{bbservices}
  s.version = "0.0.1"
  s.date = %q{2020-06-16}
  s.summary = %q{A simple service library for Ruby / Rails}
  s.files = [ "VERSION", "lib/bbservices.rb" ]
  s.files += Dir[ "lib/base/*.rb" ]
  s.require_paths = ["lib"]
end
