$: << File.join(__dir__, '..', 'lib')

require 'simplecov'
SimpleCov.start

require 'condor'

Dir[File.join(__dir__, 'support', '*.rb')].each do |support_file|
  require support_file
end

RSpec.configure do |config|
  # nothing right now
end
