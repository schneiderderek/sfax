require 'spec_helper'

RSpec.describe SFax::Encryptor do
  let(:key) { SecureRandom.hex }
  subject do
    described_class.new(key: key)
  end

  describe '#encrypt' do
    specify do
      expect { subject.encrypt('a') }.not_to raise_error
    end

    specify do
      expect(subject.encrypt('a')).to be_a String
    end
  end
end
