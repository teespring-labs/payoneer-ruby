require 'uri'

module Payoneer
  class Payee
    SIGNUP_URL_API_METHOD_NAME = 'GetToken'

    def self.signup_url(payee_id, redirect_url: nil, redirect_time: nil)
      payoneer_params = {
        p4: payee_id,
        p6: redirect_url,
        p8: redirect_time,
      }

      signup_url = Payoneer.make_api_request(SIGNUP_URL_API_METHOD_NAME, payoneer_params)

      if valid_url?(signup_url)
        signup_url
      else
        bad_response = signup_url
        fail BadResponseStatusError.new(ResponseStatus.from_response(bad_response))
      end
    end

    private

    def self.valid_url?(url)
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end
end
