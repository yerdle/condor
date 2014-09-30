module Condor
  module DSL
    module Syntax
      module Event
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def with(**options, &block)
            new_closure  = Closure.new(closure, inherit: options)
            runner = Runner.new(new_closure, Event)
            runner.eval(&block)
          end

          def concerning(event_domain, &block)
            new_closure  = Closure.new(closure, event_domain: event_domain)
            runner = Runner.new(new_closure, Domain)
            runner.eval(&block)
          end
        end
      end
    end
  end
end
