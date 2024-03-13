require 'rails_helper'

RSpec.describe ShyppleService::Rates do
  describe '.call' do
    let(:call) { described_class.call(sailing: sailing, rates: rates) }

    let(:sailing) { { 'sailing_code' => 'ABCD' } }
    let(:rates) do
      [
        { 'sailing_code' => 'ABCD', 'rate' => 1.126 },
        { 'sailing_code' => 'QWER', 'rate' => 1.1323 }
      ]
    end

    it 'returns the rate for the given sailing' do
      expect(call.value).to eq({ 'sailing_code' => 'ABCD', 'rate' => 1.126 })
    end

    context 'when the sailing is not found' do
      let(:sailing) { { 'sailing_code' => 'PSWD' } }

      it 'returns a failure' do
        expect(call).to be_failure
        expect(call.error).to eq('No rate found for sailing: PSWD')
      end
    end
  end
end