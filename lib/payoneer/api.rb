module Payoneer
  class API
    STATUS_API_METHOD_NAME = 'Echo'

    def self.status
      resp = Payoneer.make_api_request_parsed(STATUS_API_METHOD_NAME)
      ResponseStatus.from_parsed_response(resp)
    end
  end
end
