module Payoneer
  class UnexpectedResponseError < StandardError
    attr_reader :http_status
    attr_reader :http_body

    def initialize(http_status=nil, http_body=nil)
      @http_status = http_status
      @http_body = http_body
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status_string}Unexpected http response code"
    end
  end
end
