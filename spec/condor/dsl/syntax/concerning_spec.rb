require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Concerning do
        subject { Concerning }

        let(:event)  { :signup }
        let(:domain) { :board  }

        let(:closure) do
          double('closure',
            events: double('event set'),
            event: event, domain: domain,
            scope: { some_option: 'value' })
        end

        let!(:runner) { Runner.new(closure, Concerning) }

        describe '#with' do
          it 'creates a new closure with the provided context' do
            expect(Closure).to receive(:new).
              with(closure, scope: { fallback: 'unknown' })
            runner.with(fallback: 'unknown') { nil }
          end
        end

        describe '#log' do
          let(:options) do
            { fallback: 'unknown' }
          end

          it 'adds an event definition' do
            expect(closure.events).to receive(:<<).once
            runner.log(:user_id, **options) { nil }
          end
        end
      end
    end
  end
end
