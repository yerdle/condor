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

      def publish(event_name, aggregate_data)
        aggregate_data.each do |domain_name, data|
          client.publish(domain_name, Keen.transform(data, event_name))
        end
      end
    end
  end
end
