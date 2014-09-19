module Condor
  class Dispatcher

    class DataMunger
      attr_reader :event_definition
      attr_reader :data_sources

      def initialize(event_definition, data_sources)
        @event_definition = event_definition
        @data_sources = data_sources
      end

      def munge
        event_definition.domains.inject({}) do |acc, (domain, definitions)|
          properties = {}
          definitions.each do |thing_to_log|
            property = thing_to_log[0]
            properties[property] = data_sources[domain].send(property)
          end
          acc[domain] = properties
          acc
        end
      end
    end

    attr_reader :registry
    attr_reader :relays

    def initialize(registry, relays)
      @registry = registry
      @relays = relays
    end

    def dispatch(event, data_sources)
      event_definition = registry.definitions[event]
      data_munger = DataMunger.new(event_definition, data_sources)
      # not doing too much to validate data sources here, per the registry
      relays.each { |p| p.publish(event, data_munger.munge) }
    end
  end
end
