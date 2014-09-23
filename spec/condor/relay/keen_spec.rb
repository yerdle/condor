require 'spec_helper'

module Condor
  module Relay
    describe Keen do
      let(:client)     { double('client').as_null_object }
      let(:event_name) { :bid }

      let(:aggregate_data) do
        {
          community: {
            first_name: 'Joshua'
          },
          yerdle: {
            title: 'Something'
          }
        }
      end

      subject { Keen.new(client) }

      describe '#publish' do
        it 'calls publish on the client once for each domain' do
          expect(client).to receive(:publish).with(:community, {
            event_name: :bid,
            first_name: 'Joshua'
          }).once.ordered

          expect(client).to receive(:publish).with(:yerdle, {
            event_name: :bid,
            title: 'Something'
          }).once.ordered

          subject.publish(event_name, aggregate_data)
        end
      end
    end
  end
end
