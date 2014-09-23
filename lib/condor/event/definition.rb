module Condor
  module Event
    class Definition
      class Domain
        attr_reader :name
        attr_reader :loggables

        def initialize(name, loggables=nil)
          @name      = name
          @loggables = loggables || Set.new
        end

        def import(data_source)
          loggables.map { |l| [l, data_source.send(l)] }.to_h
        end
      end

      attr_reader :name
      attr_reader :domains

      def initialize(name, domains=nil)
        @name    = name
        @domains = domains || Hash.new { |h, k| h[k] = Domain.new(k) }
      end

      def define!(domain_name, loggable)
        domain = domains[domain_name]
        domain.loggables << loggable
      end
    end
  end
end
