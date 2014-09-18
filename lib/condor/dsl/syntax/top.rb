module Condor
  module DSL
    module Syntax
      module Top
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def on(event_name, &block)
            new_closure  = Closure.new(closure, event_name: event_name)
            runner = Runner.new(new_closure, Event)
            runner.eval(&block)
          end
        end
      end
    end
  end
end
