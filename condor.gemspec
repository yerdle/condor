require File.join(__dir__, 'lib', 'condor', 'version.rb')

Gem::Specification.new do |s|
  s.name        = 'condor'
  s.version     = Condor::VERSION
  s.date        = %q{2014-09-22}
  s.licenses    = []
  s.summary     = ""
  s.description = "See README at https://github.com/yerdle/condor"

  s.authors  = ['Joshua Morris', 'Hans Schoenburg']
  s.email    = 'dev+condor@yerdle.com'
  s.homepage = 'https://github.com/yerdle/condor'
  s.files    = Dir['{lib,spec}/**/*', 'README*'] & `git ls-files -z`.split("\0")

  s.add_dependency('activesupport', '>=4.0.0')
  s.add_development_dependency('rspec', '>=3.0.0')
  s.add_development_dependency('simplecov', '>=0.9.0')
end
