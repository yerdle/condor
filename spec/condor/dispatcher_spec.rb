require 'spec_helper'

module Condor
  describe Dispatcher do
    let(:events) { Registry::EventSet.new }

    let(:relays) do
      [double('relay').as_null_object, double('relay').as_null_object]
    end

    subject { Dispatcher.new(events, relays) }

    before do
      closure = DSL::Closure.new(nil, events: events)

      DSL::Runner.new(closure, DSL::Syntax::Top).eval do
        on(:signup) {
          concerning(:board) {
            with(fallback: 'unknown') {
              log :is_first_time do |req:|
                req.headers['HTTP_X_YERDLE_FIRST_UX']
              end

              log :app_version do |req:|
                req.headers['HTTP_X_YERDLE_VERSION']
              end

              log :app_build do |req:|
                req.headers['HTTP_X_YERDLE_BUILD']
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

        on(:post) {
          concerning(:board) {
            log(:auction_id) { |auction:| auction.id }
          }
        }
      end
    end

    describe '#dispatch' do
      let(:headers) do
        {
          'HTTP_X_YERDLE_FIRST_UX' => true,
          'HTTP_X_YERDLE_VERSION' => '1.0',
          'HTTP_X_YERDLE_BUILD' => '1234'
        }
      end

      let(:user) do
        double('user', id: 1, created_at: Time.now)
      end

      let(:req) { double('request', headers: headers) }

      it 'calls each relevant definition code block with context' do
        definitions = events[:signup][:board].definitions
        definitions.each do |definition|
          expect(definition.block).to receive(:call)
        end
        subject.dispatch(:signup, req: req, user: user)
      end

      it "does not call irrelevant definitions' code blocks" do
        definition = events[:post][:board][:auction_id]
        expect(definition.block).not_to receive(:call)
        subject.dispatch(:signup, req: req, user: user)
      end

      it 'calls publish on each relay' do
        relays.each do |relay|
          expect(relay).to receive(:publish).once
        end
        subject.dispatch(:signup, req: req, user: user)
      end
    end
  end
end
