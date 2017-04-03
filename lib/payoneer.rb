#Payoneer Ruby bindings
#API spec at https://github.com/teespring/payoneer-ruby
require 'rest-client'
require 'active_support'
require 'active_support/core_ext'

# Version
require 'payoneer/version'

# Configuration
require 'payoneer/configuration'

# Resources
require 'payoneer/response'
require 'payoneer/system'
require 'payoneer/payee'
require 'payoneer/payout'
require 'payoneer/payout_status'

# Errors
require 'payoneer/errors/unexpected_response_error'
require 'payoneer/errors/configuration_error'

module Payoneer
  def self.configure
    yield(configuration)
  end

  def self.make_api_request(method_name, params = {})
    configuration.validate!

    request_params = default_params.merge(mname: method_name).merge(params)

    response = RestClient.post(configuration.api_url, request_params)

    fail Errors::UnexpectedResponseError.new(response.code, response.body) unless response.code == 200

    hash_response = Hash.from_xml(response.body)
    inner_content = hash_response.values.first
    inner_content
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.default_params
    {
      p1: configuration.partner_username,
      p2: configuration.partner_api_password,
      p3: configuration.partner_id,
    }
  end
end
