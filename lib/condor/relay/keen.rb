module Condor
  module Relay
    class Keen

      attr_reader :client

      def self.transform(input)
        properties = input.dup
        properties[:event_name] = name
        properties
      end

      def initialize(client)
        @client = client
      end

      def publish(domain, name, properties)
        client.publish(domain, Keen.transform(properties))
      end

    end
  end
end
