require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Event do
         subject { Event }

        describe '#concerning' do
          let(:closure) { Closure.new(double('closure'), event_name: :signup) }
          let!(:runner) { Runner.new(closure, Event) }

          it 'creates a new closure with the provided event_domain' do
            expect(Closure).to receive(:new).
              with(closure, { event_domain: :growth })
            runner.concerning(:growth) { true }
          end

          it 'evaluates the code in the provided block in a new clean room' do
            double = double('new Runner')
            expect(Runner).to receive(:new).once.and_return(double)
            expect(double).to receive(:eval)
            runner.concerning(:growth) { true }
          end
        end
      end
    end
  end
end