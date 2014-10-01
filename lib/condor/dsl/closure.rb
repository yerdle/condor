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

      def registry
        options[:registry] || enclosure.registry
      end

      def event
        options[:event] || enclosure.event
      rescue NoMethodError
        raise ContextRequiredError, :event
      end

      def domain
        options[:domain] || enclosure.domain
      rescue NoMethodError
        raise ContextRequiredError, :domain
      end

      def scope
        to_merge = options[:scope] || {}
        enclosure.nil? ? to_merge : enclosure.scope.merge(to_merge)
      end
    end
  end
end