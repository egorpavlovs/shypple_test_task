require 'rails_helper'

RSpec.describe ShyppleService::Sources::FileSource do
  describe '.call' do
    let(:call) { described_class.call }

    before do
      allow(File).to receive(:read).and_return('{"foo": "bar"}')
    end

    it 'returns the information from the file source' do
      expect(call.value).to eq('foo' => 'bar')
    end
  end
end
