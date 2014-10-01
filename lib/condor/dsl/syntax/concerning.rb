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

          def log!(*args)
            closure.registry.define!(closure.event, closure.domain, *args)
          end
        end
      end
    end
  end
end
