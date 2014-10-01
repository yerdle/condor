require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe On do
        subject { On }

        let(:closure) { Closure.new(double('closure'), event: :signup) }
        let!(:runner) { Runner.new(closure, On) }

        describe '#with' do
          it 'creates a new closure with the provided context' do
            expect(Closure).to receive(:new).
              with(closure, scope: { fallback: 'unknown' })
            runner.with(fallback: 'unknown') { nil }
          end
        end

        describe '#concerning' do
          it 'creates a new closure with the provided domain' do
            expect(Closure).to receive(:new).
              with(closure, { domain: :growth })
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
