module Condor
  module DSL
    module Syntax
      module On
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def with(**options, &block)
            new_closure = Closure.new(closure, scope: options)
            Runner.new(new_closure, On).eval(&block)
          end

          def concerning(domain, &block)
            new_closure = Closure.new(closure, domain: domain)
            Runner.new(new_closure, Concerning).eval(&block)
          end
        end
      end
    end
  end
end
