require 'spec_helper'

module Condor
  describe Dispatcher do
    subject { Dispatcher.new(registry, relays) }

    let(:registry) { Event::Registry.new }

    let(:relays) do
      [double('relay').as_null_object, double('relay').as_null_object]
    end

    let(:data_sources) do
      {
        growth: double('data source', join_date: 'today', referrer: 'hans'),
        community: double('data source', email: 'a@b.com', first_name: 'Leroy')
      }
    end

    let(:growth_data_source)    { data_sources[:growth] }
    let(:community_data_source) { data_sources[:community] }

    let(:runner) do
      closure = DSL::Closure.new(nil, registry: registry)
      DSL::Runner.new(closure, DSL::Syntax::Top)
    end

    before do
      runner.eval do
        on(:signup) {
          concerning(:growth) {
            log! :join_date
            log! :referrer
          }
          concerning(:community) {
            log! :email
            log! :first_name
          }
        }
      end
    end

    describe '#dispatch' do
      it 'imports data for each domain with the right data source' do
        event_definition = registry.definitions[:signup]
        expect(event_definition.domains[:growth]).to receive(:import).
          with(growth_data_source)
        expect(event_definition.domains[:community]).to receive(:import).
          with(community_data_source)
        subject.dispatch(:signup, data_sources)
      end

      it 'calls publish on each relay' do
        expect(relays[0]).to receive(:publish).once
        expect(relays[1]).to receive(:publish).once
        subject.dispatch(:signup, data_sources)
      end
    end
  end
end
