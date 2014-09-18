require 'spec_helper'

module Condor
  module DSL
    describe Closure do
      let(:dispatcher)  { double('dispatcher') }

      let(:top_closure)    { Closure.new(nil, dispatcher: dispatcher) }
      let(:event_closure)  { Closure.new(top_closure, event_name: :signup) }
      let(:domain_closure) { Closure.new(event_closure, event_domain: :growth) }

      describe '#dispatcher' do
        it "delegates to closures' accessors" do
          expect(top_closure).to receive(:dispatcher).and_call_original
          expect(event_closure.dispatcher).to eq(dispatcher)
        end
      end

      describe '#event_name' do
        it "delegates to closures' accessors" do
          expect(top_closure).not_to receive(:event_name)
          expect(event_closure).to receive(:event_name).and_call_original
          expect(domain_closure.event_name).to eq(:signup)
        end

        it 'raises if not present in closure hierarchy' do
          expect { top_closure.event_name }.to raise_error
        end
      end

      describe '#event_domain' do
        it "delegates to closures' accessors" do
          expect(top_closure).not_to receive(:event_domain)
          expect(event_closure).not_to receive(:event_domain)
          expect(domain_closure.event_name).to eq(:signup)
        end

        it 'raises if not present in closure hierarchy' do
          expect { top_closure.event_domain }.to raise_error
        end
      end
    end
  end
end
