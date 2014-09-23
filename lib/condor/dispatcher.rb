module Condor
  class Dispatcher
    attr_reader :registry
    attr_reader :relays

    def initialize(registry, relays)
      @registry = registry
      @relays = relays
    end

    def dispatch(event_name, data_sources={})
      definition     = registry.definitions[event_name]
      aggregate_data = definition.domains.map do |domain_name, domain|
        data_source = data_sources[domain_name]
        [domain_name, domain.import(data_source)]
      end.to_h
      relays.each { |relay| relay.publish(event_name, aggregate_data) }
    end
  end
end
