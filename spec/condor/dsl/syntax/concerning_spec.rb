require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Concerning do
        subject { Concerning }

        let(:name)   { :signup }
        let(:domain) { :growth }

        let(:registry) { double('event registry') }
        let(:enclosure) do
          double('closure', event: name, domain: domain)
        end

        let(:closure) { Closure.new(enclosure, domain: domain) }
        let!(:runner) { Runner.new(closure, Concerning) }

        describe '#with' do
          it 'creates a new closure with the provided context' do
            expect(Closure).to receive(:new).
              with(closure, scope: { fallback: 'unknown' })
            runner.with(fallback: 'unknown') { nil }
          end
        end

        describe '#log!' do
          it 'calls define! on the event registry' do
            allow(closure).to receive(:registry).and_return(registry)
            expect(registry).to receive(:define!).with(name, domain, :title)
            runner.log!(:title)
          end
        end
      end
    end
  end
end
