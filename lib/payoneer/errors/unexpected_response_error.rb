module Payoneer
  module Errors
    class UnexpectedResponseError < StandardError
      attr_reader :http_status
      attr_reader :http_body

      def initialize(http_status = nil, http_body = nil)
        @http_status = http_status
        @http_body = http_body
      end

      def to_s
        "(Status #{http_status}) Unexpected http response code"
      end
    end
  end
end
