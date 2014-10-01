module Condor
  module DSL
    module Syntax
      module Top
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def with(**options, &block)
            new_closure = Closure.new(closure, scope: options)
            Runner.new(new_closure, Top).eval(&block)
          end

          def on(event, &block)
            new_closure = Closure.new(closure, event: event)
            Runner.new(new_closure, Event).eval(&block)
          end
        end
      end
    end
  end
end
