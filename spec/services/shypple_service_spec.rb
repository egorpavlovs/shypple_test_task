require 'rails_helper'

RSpec.describe ShyppleService do
  describe '.call' do
    let(:call) do
      described_class.call(strategy: strategy, origin_port: 'CNSHA', destination_port: 'NLRTM')
    end

    context 'when the strategy is PLS-0001' do
      let(:strategy) { 'PLS-0001' }

      before do
        allow(ShyppleService::Strategies::CheapestDirect).to receive(:call).and_return(
          ShyppleService::Utils::Result.success([{ foo: :bar }])
        )
      end

      it 'returns expected result' do
        expect(call).to be_success
        expect(call.value).to eq([{ foo: :bar }])
      end
    end

    context 'when the strategy is WRT-0002' do
      let(:strategy) { 'WRT-0002' }

      before do
        allow(ShyppleService::Strategies::CheapestIndirect).to receive(:call).and_return(
          ShyppleService::Utils::Result.success([{ foo: :bar }])
        )
      end

      it 'returns expected result' do
        expect(call).to be_success
        expect(call.value).to eq([{ foo: :bar }])
      end
    end

    context 'when the strategy is unknow' do
      let(:strategy) { 'UNK-0001' }

      it 'returns a failure' do
        expect(call).to be_failure
        expect(call.error).to eq('Invalid UNK-0001 strategy')
      end
    end
  end
end
