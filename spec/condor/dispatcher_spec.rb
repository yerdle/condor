require 'spec_helper'

module Condor

  describe Dispatcher do

    let(:registry) { Event::Registry.new }
    let(:relays) { [double('publisher one'), double('publisher two')] }
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
      it 'should call publish on each publisher' do
        expect(relays[0]).to receive(:publish).once
        expect(relays[1]).to receive(:publish).once
        subject.dispatch(:signup, data_sources)
      end
    end

    describe Dispatcher::DataMunger do
      subject { Dispatcher::DataMunger.new(registry.definitions[:signup],
                                           data_sources) }


      it 'extracts data from each source to its respective domain' do
        expect(growth_data_source).to receive(:join_date).once
        expect(growth_data_source).to receive(:referrer).once
        expect(community_data_source).to receive(:email).once
        expect(community_data_source).to receive(:first_name).once

        subject.munge
      end
    end
  end
end

