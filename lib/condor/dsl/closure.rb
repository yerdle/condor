require 'active_support/core_ext/string'

module Condor
  module DSL
    class Closure
      class ContextRequiredError < RuntimeError; end;

      attr_reader :enclosure, :options

      def initialize(enclosure, **options)
        @enclosure = enclosure
        @options   = options
      end

      # accessors via closure inheritance

      def event_registry
        options[:event_registry] || enclosure.event_registry
      end

      def event_name
        options[:event_name] || enclosure.event_name
      rescue NoMethodError
        raise ContextRequiredError, :event_name
      end

      def event_domain
        options[:event_domain] || enclosure.event_domain
      rescue NoMethodError
        raise ContextRequiredError, :event_domain
      end

      def scope
        to_merge = options[:scope] || {}
        enclosure.nil? ? to_merge : enclosure.scope.merge(to_merge)
      end
    end
  end
end