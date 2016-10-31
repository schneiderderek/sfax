require 'openssl'
require 'base64'

module SFax
  class Encryptor
    DEFAULT_IV = 'x49e*wJVXr8BrALE'.freeze
    OPEN_SSL_CIPHER = 'aes-256-cbc'.freeze

    def initialize(key:, iv: DEFAULT_IV)
      @key = key.dup
      @iv = iv
    end

    attr_reader :key, :iv

    def encrypt(plain)
      cipher = new_encrypt_cipher

      encrypted_data = cipher.update plain
      encrypted_data << cipher.final

      Base64.encode64 encrypted_data
    end

    def new_encrypt_cipher
      OpenSSL::Cipher::Cipher.new(OPEN_SSL_CIPHER).tap do |c|
        c.encrypt

        c.key = key
        c.iv = iv
      end
    end
  end
end
