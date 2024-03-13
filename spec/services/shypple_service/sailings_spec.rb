require 'rails_helper'

RSpec.describe ShyppleService::Sailings do
  describe '.call' do
    let(:call) do
      described_class.call(sailing_type: sailing_type, sailings: {}, origin_port: 'port1', destination_port: 'port2')
    end

    let(:sailing_type) { :direct }

    before do
      allow(ShyppleService::Sailings::DirectStrategy).to receive(:call).and_return({ foo: :bar })
    end

    it 'returns the sailings from the direct strategy' do
      expect(call).to eq({ foo: :bar })
    end

    context 'when the sailing type is unknown' do
      let(:sailing_type) { :unknown }

      it 'returns a failure' do
        expect(call).to be_failure
        expect(call.error).to eq('Unknown sailing type: unknown')
      end
    end
  end
end
