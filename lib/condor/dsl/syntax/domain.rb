module Condor
  module DSL
    module Syntax
      module Domain
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def log!(*args)
            closure.dispatcher.add!(closure.event_name, closure.event_domain, *args)
          end
        end
      end
    end
  end
end
