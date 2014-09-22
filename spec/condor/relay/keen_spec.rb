require 'spec_helper'

module Condor
  module Relay
    describe Keen do
      let(:client) { double('client').as_null_object }
      subject      { Keen.new(client) }

      describe '#publish' do
        it 'transforms the properties it receives' do
          expect(Keen).to receive(:transform).and_call_original
          subject.publish(:signup, :community, {})
        end

        it 'calls publish on the client with the domain and properties' do
          expect(client).to receive(:publish).once
          subject.publish(:signup, :community, {})
        end
      end

      describe '.transform' do
        subject { Keen }

        let(:input) do
          { hey: 'there', what: 'is happening'}
        end

        let(:event_name) { :good_times }

        it 'should set event_name' do
          transformed_props = subject.transform(input, event_name)
          expect(transformed_props).to include(:event_name)
          expect(transformed_props[:event_name]).to eq(event_name)
        end
      end
    end
  end
end
