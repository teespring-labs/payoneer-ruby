module Payoneer
  class Configuration
    DEVELOPMENT_ENVIRONMENT = 'development'
    PRODUCTION_ENVIRONMENT = 'production'
    DEVELOPMENT_API_URL = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
    PRODUCTION_API_URL = 'https://api.payoneer.com/Payouts/HttpApi/API.aspx?'

    attr_accessor :environment, :partner_id, :partner_username, :partner_api_password, :program_id

    def initialize
      @environment = DEVELOPMENT_ENVIRONMENT
    end

    def api_url
      environment == PRODUCTION_ENVIRONMENT ? PRODUCTION_API_URL : DEVELOPMENT_API_URL
    end

    def validate!
      fail Errors::ConfigurationError unless partner_id && partner_username && partner_api_password
    end
  end
end
