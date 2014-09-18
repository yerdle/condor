module Condor
  module Event
    describe Definition do
      describe '#adding' do
        subject { Definition.new(:signup) }

        it 'returns a copy of the definition with more data for the domain' do
          new_definition = subject.adding(:growth, :title)
          expect(new_definition.object_id).not_to eq(subject.object_id)
          expect(new_definition.domains).not_to eq(subject.domains)
        end

      end
    end
  end
end
