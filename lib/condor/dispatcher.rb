module Condor
  class Dispatcher
    attr_reader :registry
    attr_reader :publishers

    def initialize(registry, publishers)
      @registry   = registry
      @publishers = publishers
    end

    def dispatch(event, data_sources)
      # not doing too much to validate data sources here, per the registry
      publishers.each { |p| p.publish(event, data_sources) }
    end
  end
end
