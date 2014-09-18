module Condor
  class Runner < Object
    attr_reader :closure, :dsl

    def initialize(closure, dsl)
      @closure = closure
      eigenclass = (class << self; self; end)
      eigenclass.send(:include, dsl)
    end

    def eval(&block)
      unless block_given?
        raise ArgumentError, 'block must be present'
      end
      instance_eval(&block)
    end

    def parse(source)
      unless source.respond_to?(:to_str)
        raise ArgumentError, 'source must respond to #to_str'
      end
      instance_eval(source.to_str)
    end
  end
end
