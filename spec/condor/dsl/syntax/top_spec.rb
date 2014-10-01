require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Top do
        subject { Top }

        let(:registry)  { double('event registry') }
        let(:enclosure) { Closure.new(nil, registry: registry) }
        let!(:runner)   { Runner.new(enclosure, Top) }

        describe '#with' do
          it 'creates a new closure with the provided context' do
            expect(Closure).to receive(:new).
              with(enclosure, scope: { fallback: 'unknown' })
            runner.with(fallback: 'unknown') { nil }
          end
        end

        describe '#on' do
          it 'creates a new closure with the provided event' do
            expect(Closure).to receive(:new).
              with(enclosure, { event: :signup })
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
