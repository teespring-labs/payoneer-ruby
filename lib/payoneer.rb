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

# Errors
require 'payoneer/errors/unexpected_response_error'
require 'payoneer/errors/configuration_error'

module Payoneer
  DEFAULT_CURRENCY = 'USD'.freeze

  def self.configure(configs = {}, &block)
    if configs.present?
      @configurations = configs
    elsif block
      key, value = block.call(Configuration.new)
      @configurations = {}
      @configurations[key] = value
    end
  end

  def self.make_api_request(method_name, params = {})
    currency = params[:Currency]
    config = configuration_by_currency(currency)
    config.validate!

    request_params = default_params(config).merge(mname: method_name).merge(params)

    response = RestClient.post(config.api_url, request_params)

    fail Errors::UnexpectedResponseError.new(response.code, response.body) unless response.code == 200

    hash_response = Hash.from_xml(response.body)
    inner_content = hash_response.values.first
    inner_content
  end

  def self.configurations
    @configurations ||= {}
  end

  def self.configuration_by_currency(currency)
    configurations[currency] || configurations[Payoneer::DEFAULT_CURRENCY] || Configuration.new
  end

  def self.default_params(config)
    {
      p1: config.partner_username,
      p2: config.partner_api_password,
      p3: config.partner_id,
    }
  end
end
