module Condor
  module DSL
    module Syntax
      module Concerning
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def with(**options, &block)
            new_closure = Closure.new(closure, scope: options)
            Runner.new(new_closure, Concerning).eval(&block)
          end

          def log(loggable, **options, &block)
            event_list << ::Condor::Registry::Definition.new(
              event, domain, loggable, block, **scope.merge(options))
          end
        end
      end
    end
  end
end
