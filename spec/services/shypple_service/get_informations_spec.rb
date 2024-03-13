require 'rails_helper'

RSpec.describe ShyppleService::GetInformation do
  describe '.call' do
    let(:call) { described_class.call(source_type) }

    context 'when the source type is file' do
      let(:source_type) { :file }

      before do
        allow(ShyppleService::Sources::FileSource).to receive(:call).and_return({ foo: :bar })
      end

      it 'returns the information from the file source' do
        expect(call).to eq({ foo: :bar })
      end
    end

    context 'when the source type is unknown' do
      let(:source_type) { :unknown }

      it 'returns a failure' do
        expect(call).to be_failure
        expect(call.error).to eq('Unknown source type: unknown')
      end
    end
  end
end