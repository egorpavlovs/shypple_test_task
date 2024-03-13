require 'rails_helper'

RSpec.describe ShyppleService::Sailings::DirectStrategy do
  context 'when the sailings are empty' do
    let(:result) { described_class.call('AMS', 'NYC', []) }

    it 'returns a failure result' do
      expect(result).to be_failure
      expect(result.error).to eq('No suitable sailings found for AMS - NYC')
    end
  end

  context 'when the direct sailings present' do
    let(:sailings) do
      [
        { 'origin_port' => 'AMS', 'destination_port' => 'NYC', 'departure_date' => '2021-01-01' },
        { 'origin_port' => 'AMS', 'destination_port' => 'NYC', 'departure_date' => '2021-01-02' },
        { 'origin_port' => 'NYC', 'destination_port' => 'AMS', 'departure_date' => '2021-01-01' }
      ]
    end
    let(:result) { described_class.call('AMS', 'NYC', sailings) }

    it 'returns a success result' do
      expect(result).to be_success
      expect(result.value).to eq([[sailings.first], [sailings.second]])
    end
  end

  context 'when the direct sailings not present' do
    let(:sailings) do
      [
        { 'origin_port' => 'AMS', 'destination_port' => 'CNSHA', 'departure_date' => '2021-01-01' },
        { 'origin_port' => 'AMS', 'destination_port' => 'CNSHA', 'departure_date' => '2021-01-02' },
        { 'origin_port' => 'NYC', 'destination_port' => 'AMS', 'departure_date' => '2021-01-01' }
      ]
    end
    let(:result) { described_class.call('AMS', 'NYC', sailings) }

    it 'returns a failure result' do
      expect(result).to be_failure
      expect(result.error).to eq('No suitable sailings found for AMS - NYC')
    end
  end
end
