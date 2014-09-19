require 'spec_helper'

module Condor

  describe Dispatcher do

    let(:registry) { Event::Registry.new }
    let(:publishers) { [double('publisher one'), double('publisher two')] }
    subject { Dispatcher.new(registry, publishers) }

    before do
      closure = DSL::Closure.new(nil, event_registry: registry)
      dsl = DSL::Syntax::Top
      runner = DSL::Runner.new(closure, dsl)

      runner.eval do
        on(:signup) {
          concerning(:growth) {
            log!(:first_name)
            log!(:join_date)
          }
        }
      end
    end

    describe '#dispatch' do

      it 'should call publish on each publisher' do
        expect(publishers[0]).to receive(:publish).once
        expect(publishers[1]).to receive(:publish).once
        subject.dispatch(:signup, double('data source'))
      end
    end
  end
end

