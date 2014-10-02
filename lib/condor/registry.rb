module Condor
  module Registry
    Definition = Struct.new(:event, :domain, :loggable, :block, :options)

    class CachedList
      include Enumerable

      attr_reader :definitions

      def initialize(target, definitions=nil)
        @target      = target
        @definitions = definitions || []
        @cache       = {}
      end

      def <<(definition)
        definitions << definition
        cache.delete(definition.send(target))
      end

      def each(&block)
        warm!
        cache.each(&block)
      end

      protected

      def warm!
        keys = definitions.map { |d| d.send(target) }.uniq
        keys.each { |key| self[key] }
      end

      attr_accessor :cache, :target
    end

    class EventList < CachedList
      def initialize
        super(:event)
      end

      def [](event)
        unless cache.include?(event)
          defined      = definitions.select { |d| d.event == event }
          cache[event] = DomainList.new(defined) unless defined.empty?
        end
        cache[event]
      end
    end

    class DomainList < CachedList
      def initialize(definitions)
        super(:domain, definitions)
      end

      def [](domain)
        unless cache.include?(domain)
          defined       = definitions.select { |d| d.domain == domain }
          cache[domain] = LoggableList.new(defined) unless defined.empty?
        end
        cache[domain]
      end
    end

    class LoggableList < CachedList
      def initialize(definitions)
        super(:loggable, definitions)
      end

      def [](loggable)
        unless cache.include?(loggable)
          definition = definitions.find { |d| d.loggable == loggable }
          cache[loggable] = definition unless definition.nil?
        end
        cache[loggable]
      end
    end
  end
end
