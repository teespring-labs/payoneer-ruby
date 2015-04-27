#Payoneer Ruby bindings
#API spec at https://github.com/teespring/payoneer-ruby
require 'rest-client'
require 'active_support'
require 'active_support/core_ext'

# Version
require 'payoneer/version'

# Resources
require 'payoneer/response_status'
require 'payoneer/api'

# Errors
require 'payoneer/errors/bad_response_status_error'
require 'payoneer/errors/unexpected_response_error'

module Payoneer
  @environment= 'development'
  @development_api_url = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
  @production_api_url = 'https://api.payoneer.com/Payouts/HttpApi/API.aspx?'

  class << self
    attr_accessor :environment, :development_api_url, :production_api_url, :partner_id,
                  :partner_username, :partner_api_password, :default_program_id
  end

  def self.api_url
    environment == 'production' ? production_api_url : development_api_url
  end

  def self.make_api_request_parsed(method_name, params = {})
    response = Hash.from_xml(make_api_request(method_name, params))
    inner_content = response.values.first
    inner_content
  end

  def self.make_api_request(method_name, params = {})
    request_params = default_params.merge(mname: method_name).merge(params)

    res = RestClient.post(api_url, request_params)

    fail UnexpectedResponseError.new(res.code, res.body) unless res.code == 200

    res.body
  end

  private

  def self.default_params
    {
      p1: partner_username,
      p2: partner_api_password,
      p3: partner_id,
    }
  end
end
