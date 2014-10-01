require 'spec_helper'

module Condor
  module DSL
    describe Closure do
      let(:event_registry)  { double('event registry') }

      let(:top_closure)     { Closure.new(nil, event_registry: event_registry) }
      let(:event_closure)   { Closure.new(top_closure, event_name: :signup) }
      let(:scope_closure) do
        Closure.new(
           event_closure, scope: { fallback: 'unknown', especial: 'modelo' })
      end

      let(:domain_closure) do
        Closure.new(scope_closure, scope: { especial: 'overriden' })
      end

      describe '#event_registry' do
        it "delegates to closures' accessors" do
          expect(top_closure).to receive(:event_registry).and_call_original
          expect(event_closure.event_registry).to eq(event_registry)
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
