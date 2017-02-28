require 'spec_helper'

RSpec.describe SFax::Errors do
  let(:message) { SecureRandom.hex }
  let(:response) do
    {
      'isSuccess' => false,
    }
  end

  describe 'SendFaxError' do
    specify do
      error = described_class::SendFaxError.new

      expect(error.message).to eq('An error occurred while submitting the fax for sending.')
      expect(error.response).to eq(nil)
    end

    specify do
      error = described_class::SendFaxError.new(message: message)

      expect(error.message).to eq(message)
      expect(error.response).to eq(nil)
    end

    specify do
      error = described_class::SendFaxError.new(message: message, response: response)

      expect(error.message).to eq(message)
      expect(error.response).to eq(response)
    end
  end
end
