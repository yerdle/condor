require 'spec_helper'

module Condor
  module DSL
    describe Runner do
      let(:syntax) do
        Module.new do
          def self.included(receiver)
            receiver.send :include, InstanceMethods
          end

          module InstanceMethods
            def foo
            end
          end
        end
      end

      subject { Runner.new(double('closure'), syntax) }

      describe '#eval' do
        it 'requires a block' do
          expect {
            subject.eval
          }.to raise_error ArgumentError
        end

        it 'evaluates the block in the context of the runner' do
          expect {
            subject.eval { foo }
          }.not_to raise_error

          expect {
            subject.eval { bar }
          }.to raise_error NameError

          expect(subject).to receive(:instance_eval).once
          subject.eval { foo }
        end
      end

      describe '#parse' do
        let(:to_str) do
          Class.new do
            def to_str
              "foo"
            end
          end.new
        end

        it 'requires a #to_str' do
          expect {
            subject.parse
          }.to raise_error ArgumentError

          expect {
            subject.parse []
          }.to raise_error ArgumentError

          expect {
            subject.parse to_str
          }.not_to raise_error
        end

        it 'parses the string in the context of the runner' do
          expect(to_str).to receive(:to_str).and_call_original
          expect(subject).to receive(:instance_eval).and_call_original
          subject.parse to_str
        end
      end
    end
  end
end
