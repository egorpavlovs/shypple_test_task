require 'rails_helper'

RSpec.describe ShyppleService::ExchangeRates do
  describe '.call' do
    let(:call) do
      described_class.call(date: '2022-02-01', currency: 'usd', exchange_rates: exchange_rates)
    end

    let(:exchange_rates) do
      {
        '2022-02-01' => {
          'usd' => 1.126,
          'jpy' => 130.15
        },
        '2022-02-02' => {
          'usd' => 1.1323,
          'jpy' => 133.91
        }
      }
    end

    it 'returns the exchange rate for the given date and currency' do
      expect(call.value).to eq(1.126)
    end

    context 'when the date is not found' do
      let(:call) do
        described_class.call(date: '2022-02-03', currency: 'USD', exchange_rates: exchange_rates)
      end

      it 'returns a failure' do
        expect(call).to be_failure
        expect(call.error).to eq('No exchange rates found for date: 2022-02-03')
      end
    end

    context 'when the currency is not found' do
      let(:call) do
        described_class.call(date: '2022-02-01', currency: 'EUR', exchange_rates: exchange_rates)
      end

      it 'returns a failure' do
        expect(call).to be_failure
        expect(call.error).to eq('No exchange rates found for currency: eur')
      end
    end
  end
end
