module Condor
  class Dispatcher
    attr_reader :registry
    attr_reader :relays

    def initialize(registry, relays)
      @registry = registry
      @relays = relays
    end

    def dispatch(event, data_sources={})
      definition     = registry.definitions[event]
      aggregate_data = definition.domains.map do |name, domain|
        data_source = data_sources[name]
        [name, domain.munge(data_source)]
      end.to_h
      relays.each { |relay| relay.publish(event, aggregate_data) }
    end
  end
end
