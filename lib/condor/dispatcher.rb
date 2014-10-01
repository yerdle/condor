module Condor
  class Dispatcher
    attr_reader :registry
    attr_reader :relays

    def initialize(registry, relays)
      @registry = registry
      @relays = relays
    end

    def dispatch(event, data_sources={})
      aggregate_data = registry.definitions[event].domains.map do |name, domain|
        [name, domain.import(data_sources[name])]
      end.to_h
      relays.each { |relay| relay.publish(event, aggregate_data) }
    end
  end
end
