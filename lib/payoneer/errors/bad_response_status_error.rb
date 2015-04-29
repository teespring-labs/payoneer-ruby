module Payoneer
  class BadResponseStatusError < StandardError
    attr_reader :response_status

    def initialize(response_status)
      @response_status = response_status
    end

    def to_s
      "(Status Code: #{response_status.code}, Description: #{response_status.description}) Payoneer responded with an error status."
    end

  end
end
