require 'spec_helper'

RSpec.describe SFax::Client do
  subject do
    described_class.new(
      username: username,
      api_key: api_key,
      encryption_key: encryption_key,
    )
  end
  let(:username) { SecureRandom.hex }
  let(:api_key) { SecureRandom.hex }
  let(:encryption_key) { SecureRandom.hex }

  describe '#send_fax' do
    let(:fax_number) { nil }
    let(:file) { StringIO.new('data') }
    let(:recipient_name) { nil }
    let(:token) { SecureRandom.hex }
    let(:send_fax_queue_id) { rand(1_000_000) }
    let!(:send_fax_request) do
      stub_request(:post, 'https://api.sfaxme.com/api/sendfax').with(query: {
        'token' => token,
        'ApiKey' => api_key,
        'RecipientFax' => fax_number,
        'RecipientName' => recipient_name,
      }).and_return(body: {
        'SendFaxQueueId' => send_fax_queue_id,
      }.to_json)
    end

    before do
      # I'd prefer not to stub this, but I think this is the easiest way
      # currently.
      allow(subject).to receive(:generate_token).and_return(token)
    end

    context 'valid fax number' do
      let(:fax_number) { '15555555555' }

      context 'valid send_fax_queue_id in response' do
        let(:send_fax_queue_id) { rand(1_000_000) }

        specify do
          response = subject.send_fax(fax_number: fax_number, file: file, recipient_name: recipient_name)

          expect(response.fax_id).to eq send_fax_queue_id
          expect(send_fax_request).to have_been_requested
        end
      end

      context 'send_fax_queue_id is -1' do
        let(:send_fax_queue_id) { -1 }

        specify do
          expect {
            subject.send_fax(fax_number: fax_number, file: file, recipient_name: recipient_name)
          }.to raise_error(described_class::SendFaxError)

          expect(send_fax_request).to have_been_requested
        end
      end
    end

    shared_examples :invdalid_fax_number_error do
      specify do
        expect {
          subject.send_fax(fax_number: fax_number, file: file, recipient_name: recipient_name)
        }.to raise_error(described_class::InvalidFaxNumberError)
      end
    end

    context 'fax number 10 digits' do
      let(:fax_number) { '5555555555' }

      include_examples :invdalid_fax_number_error
    end

    context 'fax number not a number' do
      let(:fax_number) { 'a' }

      include_examples :invdalid_fax_number_error
    end
  end
end
