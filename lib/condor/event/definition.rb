module Condor
  module Event
    class Definition
      attr_reader :name
      attr_reader :domains

      def initialize(name, domains=nil)
        @name    = name
        @domains = domains || Hash.new { |h, k| h[k] = [] }
      end

      def adding(domain, *params)
        definition = dup
        definition.domains[domain] << params
        definition
      end

      def dup
        Definition.new(name, domains.dup)
      end
    end
  end
end
