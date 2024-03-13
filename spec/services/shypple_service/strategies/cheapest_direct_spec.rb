require 'rails_helper'

RSpec.describe ShyppleService::Strategies::CheapestDirect do
  describe '.call' do
    let(:call) { described_class.call(origin_port: 'CNSHA', destination_port: 'NLRTM') }

    context 'when the sailings are present' do
      before do
        allow(ShyppleService::GetInformation).to receive(:call).and_return(
          ShyppleService::Utils::Result.success(
          # TODO: Move to fixtures
            {
              "sailings": [
                {
                  "origin_port": 'CNSHA',
                  "destination_port": 'NLRTM',
                  "departure_date": '2022-02-01',
                  "arrival_date": '2022-03-01',
                  "sailing_code": 'ABCD'
                },
                {
                  "origin_port": 'CNSHA',
                  "destination_port": 'NLRTM',
                  "departure_date": '2022-02-02',
                  "arrival_date": '2022-03-02',
                  "sailing_code": 'EFGH'
                }
              ],
              "rates": [
                {
                  "sailing_code": 'ABCD',
                  "rate": '589.30',
                  "rate_currency": 'USD'
                },
                {
                  "sailing_code": 'EFGH',
                  "rate": '890.32',
                  "rate_currency": 'EUR'
                }
              ],
              "exchange_rates": {
                "2022-02-01": {
                  "usd": 1.126,
                  "jpy": 130.15
                },
                "2022-02-02": {
                  "usd": 1.1323,
                  "jpy": 133.91
                }
              }
            }
          )
        )
      end

      it 'returns the cheapest direct sailing' do
        expect(call).to be_success
        expect(call.value).to eq(
          [
            {
              'arrival_date'     => '2022-03-01',
              'departure_date'   => '2022-02-01',
              'destination_port' => 'NLRTM',
              'origin_port'      => 'CNSHA',
              'rate'             => '589.30',
              'rate_currency'    => 'USD',
              'sailing_code'     => 'ABCD'
            }
          ]
        )
      end
    end

    context 'when the sailings are not present' do
      let(:error_message) { 'No sailings found for CNSHA -> NLRTM route.' }

      before do
        allow(ShyppleService::Sailings).to receive(:call).and_return(
          ShyppleService::Utils::Result.failure(error_message)
        )
      end

      it 'returns an failed value' do
        expect(call).to be_failure
        expect(call.error).to eq(error_message)
      end
    end
  end
end
