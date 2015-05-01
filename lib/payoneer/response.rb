module Payoneer
  class Response
    attr_reader :code, :body

    OK_STATUS_CODE = '000'

    def self.new_ok_response(body)
      new(OK_STATUS_CODE, body)
    end

    def initialize(code, body)
      @code = code
      @body = body
    end

    def ok?
      code == OK_STATUS_CODE
    end

    def ==(other)
      code == other.code && body == other.body
    end
  end
end
