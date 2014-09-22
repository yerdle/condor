module Condor
  module Relay
    class Keen

      attr_reader :client

      def self.transform(input, event_name)
        properties = input.dup
        properties[:event_name] = event_name
        properties
      end

      def initialize(client)
        @client = client
      end

      def publish(domain, name, properties)
        client.publish(domain, Keen.transform(properties, name))
      end

    end
  end
end
