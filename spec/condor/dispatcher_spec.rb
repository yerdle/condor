require 'spec_helper'

module Condor

  describe Dispatcher do

    let(:registry) { Event::Registry.new }
    let(:relays) do
      [
        double('relay one').as_null_object,
        double('relay two').as_null_object
      ]
    end

    subject { Dispatcher.new(registry, relays) }

    let(:growth_data_source) do
      double('data source', join_date: 'today', referrer: 'hans')
    end

    let(:community_data_source) do
      double('data source', email: 'quack@allday.com', first_name: 'Leroy')
    end

    let(:data_sources) do
      {
        growth: growth_data_source,
        community: community_data_source
      }
    end

    before do
      closure = DSL::Closure.new(nil, event_registry: registry)
      dsl = DSL::Syntax::Top
      runner = DSL::Runner.new(closure, dsl)

      runner.eval do
        on(:signup) {
          concerning(:growth) {
            log!(:join_date)
            log!(:referrer)
          }
          concerning(:community) {
            log!(:email)
            log!(:first_name)
          }
        }
      end
    end

    describe '#dispatch' do
      it 'munges data for each domain with the right data source' do
        event_definition = registry.definitions[:signup]
        expect(event_definition.domains[:growth]).to receive(:munge).
          with(growth_data_source)
        expect(event_definition.domains[:community]).to receive(:munge).
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
