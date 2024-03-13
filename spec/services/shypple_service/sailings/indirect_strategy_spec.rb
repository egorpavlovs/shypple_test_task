require 'rails_helper'

RSpec.describe ShyppleService::Sailings::IndirectStrategy do
  let(:result) { described_class.call('AMS', 'NYC', sailings) }

  context 'when the direct sailings present' do
    let(:sailings) do
      [
        { origin_port: 'AMS', destination_port: 'NYC', departure_date: '2021-01-01', arrival_date: '2021-01-02' },
        { origin_port: 'AMS', destination_port: 'NYC', departure_date: '2021-01-02', arrival_date: '2021-01-03' },
        { origin_port: 'NYC', destination_port: 'AMS', departure_date: '2021-01-01', arrival_date: '2021-01-02' }
      ]
    end

    it 'returns a success result' do
      expect(result).to be_success
      expect(result.value).to eq([[sailings.first], [sailings.second]])
    end
  end

  context 'when the indirect sailings present' do
    let(:sailings) do
      [
        { origin_port: 'AMS', destination_port: 'BRZ', departure_date: '2021-01-01', arrival_date: '2021-02-02' },
        { origin_port: 'BRZ', destination_port: 'EGR', departure_date: '2021-03-03', arrival_date: '2021-04-04' },
        { origin_port: 'EGR', destination_port: 'NYC', departure_date: '2021-05-05', arrival_date: '2021-06-06' },
        { origin_port: 'EGR', destination_port: 'SPS', departure_date: '2021-05-05', arrival_date: '2021-06-06' },

        { origin_port: 'AMS', destination_port: 'BRZ', departure_date: '2022-01-01', arrival_date: '2022-02-02' },
        { origin_port: 'BRZ', destination_port: 'EGR', departure_date: '2022-03-03', arrival_date: '2022-04-04' },
        { origin_port: 'EGR', destination_port: 'NYC', departure_date: '2022-05-05', arrival_date: '2022-06-06' }
      ]
    end

    it 'returns a success result' do
      expect(result).to be_success
      expect(result.value).to eq(
        [
          [
            {
              origin_port: 'AMS', destination_port: 'BRZ',
              departure_date: '2021-01-01', arrival_date: '2021-02-02'
            },
            {
              origin_port: 'BRZ', destination_port: 'EGR',
              departure_date: '2021-03-03', arrival_date: '2021-04-04'
            },
            {
              origin_port: 'EGR', destination_port: 'NYC',
              departure_date: '2021-05-05', arrival_date: '2021-06-06'
            }
          ],
          [
            {
              origin_port: 'AMS', destination_port: 'BRZ',
              departure_date: '2021-01-01', arrival_date: '2021-02-02'
            },
            {
              origin_port: 'BRZ', destination_port: 'EGR',
              departure_date: '2021-03-03', arrival_date: '2021-04-04'
            },
            {
              origin_port: 'EGR', destination_port: 'NYC',
              departure_date: '2022-05-05', arrival_date: '2022-06-06'
            }
          ],
          [
            {
              origin_port: 'AMS', destination_port: 'BRZ',
              departure_date: '2021-01-01', arrival_date: '2021-02-02'
            },
            {
              origin_port: 'BRZ', destination_port: 'EGR',
              departure_date: '2022-03-03', arrival_date: '2022-04-04'
            },
            {
              origin_port: 'EGR', destination_port: 'NYC',
              departure_date: '2022-05-05', arrival_date: '2022-06-06'
            }
          ],
          [
            {
              origin_port: 'AMS', destination_port: 'BRZ',
              departure_date: '2022-01-01', arrival_date: '2022-02-02'
            },
            {
              origin_port: 'BRZ', destination_port: 'EGR',
              departure_date: '2022-03-03', arrival_date: '2022-04-04'
            },
            {
              origin_port: 'EGR', destination_port: 'NYC',
              departure_date: '2022-05-05', arrival_date: '2022-06-06'
            }
          ]
        ]
      )
    end
  end

  context 'when suitable sailings not found' do
    let(:sailings) do
      [
        { origin_port: 'AMS', destination_port: 'EGR', departure_date: '2021-01-01', arrival_date: '2021-01-02' },
        { origin_port: 'EGR', destination_port: 'NYC', departure_date: '2020-01-02', arrival_date: '2021-01-03' },

        { origin_port: 'NYC', destination_port: 'AMS', departure_date: '2021-01-01', arrival_date: '2021-01-02' }
      ]
    end

    it 'returns a success result' do
      expect(result).to be_failure
      expect(result.error).to eq('No suitable sailings found for AMS -> NYC route.')
    end
  end

end
