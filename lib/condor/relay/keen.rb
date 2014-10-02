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

      def publish(event, event_data)
        event_data.each do |domain, domain_data|
          transform = Keen.transform(domain_data, event)
          client.publish(domain, transform)
        end
      end
    end
  end
end
