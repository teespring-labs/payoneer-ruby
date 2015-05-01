module Payoneer
  class System
    STATUS_METHOD_NAME = 'Echo'

    def self.status
      resp = Payoneer.make_api_request(STATUS_METHOD_NAME)
      Response.new(resp['Status'], resp['Description'])
    end
  end
end
