require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Domain do
        subject { Domain }

        describe '#log!' do
          let(:name)   { :signup }
          let(:domain) { :growth }

          let(:event_registry) { double('event registry') }
          let(:enclosure) do
            double('closure', event_name: name, event_domain: domain)
          end

          let(:closure) { Closure.new(enclosure, event_domain: domain) }
          let!(:runner) { Runner.new(closure, Domain) }

          it 'calls define! on the event registry' do
            allow(closure).to receive(:event_registry).and_return(event_registry)
            expect(event_registry).to receive(:define!).with(name, domain, :title)
            runner.log!(:title)
          end
        end
      end
    end
  end
end
