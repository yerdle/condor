module Condor
  module Event
    class Registry
      attr_reader :schemas
      attr_reader :definitions

      def initialize
        @definitions = Hash.new { |d, n| d[n] = Definition.new(n) }
      end

      def define!(name, domain, *params)
        definitions[name] = definitions[name].adding(domain, *params)
      end
    end
  end
end
