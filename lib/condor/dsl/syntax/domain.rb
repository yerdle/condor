module Condor
  module DSL
    module Syntax
      module Domain
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def with(**options, &block)
            new_closure  = Closure.new(closure, inherit: options)
            runner = Runner.new(new_closure, Domain)
            runner.eval(&block)
          end

          def log!(*args)
            closure.event_registry.
              define!(closure.event_name, closure.event_domain, *args)
          end
        end
      end
    end
  end
end
