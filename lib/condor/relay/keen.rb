module Condor
  module Relay
    class Keen
      attr_reader :client

      def self.transform(input, event)
        input.merge(event: event)
      end

      def initialize(client)
        @client = client
      end

      def publish(event, aggregate_data)
        aggregate_data.each do |domain, data|
          client.publish(domain, Keen.transform(data, event))
        end
      end
    end
  end
end
