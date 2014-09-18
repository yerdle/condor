require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Top do
        subject { Top }

        describe '#on' do
          let(:event_registry) { double('event registry') }
          let(:enclosure) { Closure.new(nil, event_registry: event_registry) }
          let!(:runner)   { Runner.new(enclosure, Top) }

          it 'creates a new closure with the provided event' do
            expect(Closure).to receive(:new).
              with(enclosure, { event_name: :signup })
            runner.on(:signup) { nil }
          end

          it 'evaluates the code in the provided block in a new clean room' do
            double = double('new Runner')
            expect(Runner).to receive(:new).once.and_return(double)
            expect(double).to receive(:eval)
            runner.on(:signup) { nil }
          end
        end
      end
    end
  end
end
