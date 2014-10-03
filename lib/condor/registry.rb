module Condor
  module Registry
    Definition = Struct.new(:event, :domain, :loggable, :block, :options)

    class DefinitionSet
      include Enumerable

      attr_reader :definitions

      delegate :each, to: :by_matcher

      def initialize(matcher, list=nil)
        @matcher     = matcher
        @definitions = list || []
        @by_matcher  = {}

        keys = definitions.map { |d| d.send(matcher) }.uniq
        keys.each { |key| self[key] }
      end

      def <<(definition)
        definitions << definition

        detail             = definition.send(matcher)
        by_matcher[detail] = construct(detail)

        self
      end

      protected

      attr_accessor :by_matcher, :matcher
    end

    class EventSet < DefinitionSet
      def initialize()
        super(:event)
      end

      def [](event)
        by_matcher[event] ||= construct(event)
      end

      private

      def construct(event)
        DomainSet.new(definitions.select { |d| d.event == event })
      end
    end

    class DomainSet < DefinitionSet
      def initialize(definitions)
        super(:domain, definitions)
      end

      def [](domain)
        by_matcher[domain] ||= construct(domain)
      end

      private

      def construct(domain)
        LoggableSet.new(definitions.select { |d| d.domain == domain })
      end
    end

    class LoggableSet < DefinitionSet
      def initialize(definitions)
        super(:loggable, definitions)
      end

      def [](loggable)
        by_matcher[loggable] ||= construct(loggable)
      end

      private

      def construct(loggable)
        definitions.find { |d| d.loggable == loggable }
      end
    end
  end
end
