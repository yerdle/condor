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
    end
  end
end
