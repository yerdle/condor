require 'spec_helper'

module Condor
  module Relay
    describe Keen do
      let(:client) { double('client').as_null_object }
      let(:event)  { :bid }

      let(:aggregate_data) do
        {
          community: { first_name: 'Joshua' },
          yerdle: { title: 'Something' }
        }
      end

      subject { Keen.new(client) }

      describe '#publish' do
        it 'calls publish on the client once for each domain' do
          expect(client).to receive(:publish).with(:community, {
            event: :bid,
            first_name: 'Joshua'
          }).once.ordered

          expect(client).to receive(:publish).with(:yerdle, {
            event: :bid,
            title: 'Something'
          }).once.ordered

          subject.publish(event, aggregate_data)
        end
      end
    end
  end
end
