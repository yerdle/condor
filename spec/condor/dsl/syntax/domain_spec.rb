require 'spec_helper'

module Condor
  module DSL
    module Syntax
      describe Domain do
        subject { Domain }

        describe '#log!' do
          let(:name)   { :signup }
          let(:domain) { :growth }

          let(:dispatcher) { double('dispatcher') }
          let(:enclosure) do
            double('closure', event_name: name, event_domain: domain)
          end

          let(:closure) { Closure.new(enclosure, event_domain: domain) }
          let!(:runner) { Runner.new(closure, Domain) }

          it 'calls add! on the dispatcher' do
            expect(closure).to receive(:dispatcher).and_return(dispatcher)
            expect(dispatcher).to receive(:add!).with(name, domain, :title)
            runner.log!(:title)
          end
        end
      end
    end
  end
end
