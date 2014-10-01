require 'spec_helper'

module Condor
  describe Dispatcher do
    subject { Dispatcher.new(event_list, relays) }

    let(:event_list) { Registry::EventList.new }

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
      closure = DSL::Closure.new(nil, event_list: event_list)
      DSL::Runner.new(closure, DSL::Syntax::Top)
    end

    before do
      runner.eval do
        on(:signup) {
          concerning(:board) {
            with(fallback: 'unknown') {
              log :is_first_time do |req:|
                request.headers['HTTP_X_YERDLE_FIRST_UX']
              end

              log :app_version do |req:|
                request.headers['HTTP_X_YERDLE_VERSION']
              end

              log :app_build do |req:|
                request.headers['HTTP_X_YERDLE_BUILD']
              end

              log :user_join_time do |user:|
                user.try(:created_at)
              end

              log :user_id do |user:|
                user.try(:id)
              end
            }
          }
        }
      end
    end

    describe '#dispatch' do
      it 'imports data for each domain with the right data source'
      it 'calls publish on each relay'
    end
  end
end
