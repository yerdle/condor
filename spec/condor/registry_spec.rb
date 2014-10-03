require 'spec_helper'

module Condor
  module Registry
    describe EventSet do
      let(:a) { Definition.new(:signup, :board, :is_first_time, ->{}, a: 'a') }
      let(:b) { Definition.new(:signup, :board, :app_version, ->{}, a: '1') }
      let(:c) { Definition.new(:signup, :board, :app_build, ->{}, a: '-') }
      let(:d) { Definition.new(:signup, :board, :user_id, ->{}, b: 'a') }

      before do
        subject << a
        subject << b
        subject << c
        subject << d
      end

      it 'caches access' do
        object_id = subject[:signup].object_id
        expect(object_id).to eq(object_id)
        subject << Definition.new(:signup, :board, :user_join_time, ->{})
        expect(subject[:signup].object_id).not_to eq(object_id)
      end

      it 'accepts items like an array' do
        expect(subject.definitions.length).to eq(4)
      end

      it 'allows access by event name' do
        expect(subject[:signup]).not_to be_nil
        expect(subject[:signup]).to respond_to(:[])
      end

      it 'allows access by domains, given an event' do
        expect(subject[:signup][:board]).not_to be_nil
        expect(subject[:signup][:board]).to respond_to(:[])
      end

      it 'allows access to loggables, given an event and a domain' do
        expect(subject[:signup][:board][:is_first_time]).not_to be_nil
        expect(subject[:signup][:board][:app_version]).not_to be_nil
        expect(subject[:signup][:board][:app_build]).not_to be_nil
        expect(subject[:signup][:board][:user_id]).not_to be_nil
      end
    end
  end
end