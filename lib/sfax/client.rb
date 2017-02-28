require 'sfax/encryptor'
require 'sfax/version'
require 'sfax/constants'
require 'faraday'
require 'json'

module SFax
  class Client
    include Constants
    include Errors

    def initialize(username:, api_key:, encryption_key:)
      @username = username
      @api_key = api_key
      @encryptor = SFax::Encryptor.new(key: encryption_key)
    end

    def send_fax(fax_number:, file:, recipient_name:)
      validate_fax_number fax_number

      response = connection.post SEND_FAX_PATH do |request|
        request.params = {
          'token' => generate_token,
          'ApiKey' => api_key,
          'RecipientFax' => fax_number,
          'RecipientName' => recipient_name,
        }
        request.body = {
          file: Faraday::UploadIO.new(file, 'application/pdf', "#{gen_dt}.pdf")
        }
      end

      response_object = JSON.parse(response.body)
      # TODO: Refactor into proper response objec.
      def response_object.fax_id
        fetch('SendFaxQueueId')
      end

      def response_object.success?
        fetch('isSuccess')
      end

      def response_object.message
        fetch('message')
      end

      response_object.tap do |o|
        raise SendFaxError.new(message: o.message, response: o) unless o.success?
        raise SendFaxError.new(message: o.message, response: o) if o.fax_id.to_s == SEND_FAX_QUEUE_ID_ERROR_VALUE
      end
    end

    private

    def connection
      @connection ||= Faraday.new(url: SFAX_URL) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end

    attr_reader :username, :api_key, :encryptor

    def generate_token
      encryptor.encrypt "Username=#{username}&ApiKey=#{api_key}&GenDT=#{gen_dt}"
    end

    def gen_dt
      Time.now.utc.iso8601
    end

    def validate_fax_number(number)
      if number.to_i == 0 || number.length != 11
        raise InvalidFaxNumberError, "Expected an 11 digit fax number. Got: #{number}"
      end
    end
  end
end
