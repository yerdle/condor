require 'spec_helper'

module Condor
  describe Extractor do
    let(:events) { Registry::EventSet.new }

    subject { described_class.new(events[:signup], input: input) }

    before do
      closure = DSL::Closure.new(nil, events: events)

      DSL::Runner.new(closure, DSL::Syntax::Top).eval do
        on(:signup) {
          concerning(:board) {
            log(:foo) { |input:| input.foo }
            log(:bar) { |input:| input['bar'] }
            log(:baz) { 3 }
          }
        }
      end
    end

    context 'with valid input' do
      let(:input) do
        Class.new do
          def foo
            1
          end

          def [](key)
            2
          end
        end.new
      end

      it 'generates the correct output' do
        expect(subject.run).to eq(
          { :board => { :foo => 1, :bar => 2, :baz => 3 } }
        )
      end
    end

    context 'with invalid input' do
      let(:input) do
        Class.new do
          def foo
            1
          end
        end.new
      end

      it 'raises a descriptive error' do
        expect {
          subject.run
        }.to raise_error(described_class::InvalidInput, /bar/)
      end
    end
  end
end
