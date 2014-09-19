require 'spec_helper'

module Condor
  module Relay
    describe Keen do
      let(:client) { double('client').as_null_object }
      subject      { Keen.new(client) }

      describe '#publish' do
        it 'transforms the properties it receives' do
          expect(Keen).to receive(:transform)
          subject.publish(:signup, :community, {})
        end

        it 'calls publish on the client with the domain and properties' do
          expect(client).to receive(:publish).once
          subject.publish(:signup, :community, {})
        end
      end
    end
  end
end
