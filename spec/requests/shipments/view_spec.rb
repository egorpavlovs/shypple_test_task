require 'rails_helper'

RSpec.describe 'Shipment request' do
  context 'when shipment not found' do
    let(:error_message) { 'Shipment not found' }
    before do
      allow(ShyppleService).to receive(:call).and_return(ShyppleService::Utils::Result.failure(error_message))
    end

    it 'returns not found' do
      get '/shipments/AAAA?origin_port=BBB&destination_port=CCC'

      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq(error_message)
    end
  end

  context 'when shipment found' do
    let(:shipment) { [{ foo: :bar }] }
    before do
      allow(ShyppleService).to receive(:call).and_return(ShyppleService::Utils::Result.success(shipment))
    end

    it 'returns the shipment' do
      get '/shipments/AAAA?origin_port=BBB&destination_port=CCC'

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(shipment.to_json)
    end
  end
end
