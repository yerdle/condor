require 'spec_helper'

module Condor
  module DSL
    describe Closure do
      let(:events) { double('event set') }

      let(:top_closure)   { Closure.new(nil, events: events) }
      let(:event_closure) { Closure.new(top_closure, event: :signup) }

      let(:scope_closure) do
        Closure.new(
           event_closure, scope: { fallback: 'unknown', especial: 'modelo' })
      end

      let(:domain_closure) do
        Closure.new(scope_closure, scope: { especial: 'overriden' })
      end

      describe '#events' do
        it "delegates to closures' accessors" do
          expect(top_closure).to receive(:events).and_call_original
          expect(event_closure.events).to eq(events)
        end
      end

      describe '#event' do
        it "delegates to closures' accessors" do
          expect(top_closure).not_to receive(:event)
          expect(event_closure).to receive(:event).and_call_original
          expect(domain_closure.event).to eq(:signup)
        end

        it 'raises if not present in closure hierarchy' do
          expect { top_closure.event }.to raise_error
        end
      end

      describe '#domain' do
        it "delegates to closures' accessors" do
          expect(top_closure).not_to receive(:domain)
          expect(event_closure).not_to receive(:domain)
          expect(domain_closure.event).to eq(:signup)
        end

        it 'raises if not present in closure hierarchy' do
          expect { top_closure.domain }.to raise_error
        end
      end

      describe '#scope' do
        it 'aggregates scopes recursively, inheriting' do
          expect(domain_closure.scope[:fallback]).to eq('unknown')
        end

        it 'respects inheritance--overrides get priority' do
          expect(domain_closure.scope[:especial]).to eq('overriden')
        end
      end
    end
  end
end
