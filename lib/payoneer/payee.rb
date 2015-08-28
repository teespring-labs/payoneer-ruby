require 'uri'

module Payoneer
  class Payee
    SIGNUP_URL_API_METHOD_NAME = 'GetToken'
    PAYEE_DETAILS_API_METHOD_NAME = 'GetPayeeDetails'

    def self.signup_url(payee_id, redirect_url: nil, redirect_time: nil)
      payoneer_params = {
        p4: payee_id,
        p6: redirect_url,
        p8: redirect_time,
        p9: Payoneer.configuration.auto_approve_sandbox_accounts?,
        p10: true, # returns an xml response
      }

      response = Payoneer.make_api_request(SIGNUP_URL_API_METHOD_NAME, payoneer_params)

      if success?(response)
        Response.new_ok_response(response['Token'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    def self.details(payee_id)
      payoneer_params = {
        p4: payee_id
      }

      response = Payoneer.make_api_request(PAYEE_DETAILS_API_METHOD_NAME, payoneer_params)

      if success?(response)
        Response.new_ok_response(response['Payee'])
      else
        Response.new(response['Code'], response['Description'])
      end
    end

    private

    def self.success?(response)
      !response.has_key?('Code')
    end

  end
end
