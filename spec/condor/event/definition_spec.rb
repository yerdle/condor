require 'spec_helper'

module Condor
  module Event
    describe Definition::Domain do
      subject { Definition::Domain.new(:growth) }

      before do
        subject.loggables << :email
        subject.loggables << :first_name
      end

      describe '#import' do
        let(:data_source) do
          double('data source', email: 'quack@allday.com', first_name: 'Phil')
        end

        it 'asks the data source for data' do
          expect(data_source).to receive(:email).once
          expect(data_source).to receive(:first_name).once
          subject.import(data_source)
        end
      end
    end

    describe Definition do
      describe '#define!' do
        subject { Definition.new(:signup) }

        let(:domain_name) { :growth }
        let(:loggable)    { :first_name }

        it 'creates a new domain if never encountered' do
          subject.define!(domain_name, loggable)
          expect(subject.domains).to include(domain_name)
        end

        it 'defines a loggable on the new domain' do
          subject.define!(domain_name, loggable)
          expect(subject.domains[domain_name].loggables).to include(loggable)
        end
      end
    end
  end
end
