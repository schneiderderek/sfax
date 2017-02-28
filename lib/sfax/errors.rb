
module SFax
  module Errors
    class SendFaxError < StandardError
      attr_reader :response
      DEFAULT_MESSAGE = 'An error occurred while submitting the fax for sending.'.freeze

      def initialize(message: DEFAULT_MESSAGE, response: nil)
        @response = response
        super(message)
      end
    end

    InvalidFaxNumberError = Class.new(StandardError)
  end
end
