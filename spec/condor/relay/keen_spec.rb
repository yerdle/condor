require 'spec_helper'

module Condor
  module Relay
    describe Keen do
      let(:fake_client) { double('keen client').as_null_object }

      subject { Keen.new(fake_client) }

      describe '#publish' do
        let(:event)      { :signup }
        let(:event_data) { { board: { is_first_time: true } } }

        it 'transforms input' do
          expect(described_class).to receive(:transform).and_call_original
          subject.publish(:signup, event_data)
        end

        it 'publishes transformed input' do
          expect(described_class).to receive(:transform).once.ordered
          expect(fake_client).to receive(:publish).once.ordered
          subject.publish(:signup, event_data)
        end
      end
    end
  end
end
