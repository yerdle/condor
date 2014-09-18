require 'spec_helper'

module Condor
  module Event
    describe Registry do
      describe '#define!' do
        subject { Event::Registry.new }

        it 'creates a definition' do
          expect {
            subject.define!(:signup, :growth, :title)
          }.to change(subject.definitions, :count).by(1)
        end
      end
    end
  end
end
