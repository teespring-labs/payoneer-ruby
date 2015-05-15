module Payoneer
  class Configuration
    DEVELOPMENT_ENVIRONMENT = 'development'
    PRODUCTION_ENVIRONMENT = 'production'
    DEVELOPMENT_API_URL = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
    PRODUCTION_API_URL = 'https://api.payoneer.com/Payouts/HttpApi/API.aspx?'

    attr_accessor :environment, :partner_id, :partner_username, :partner_api_password, :auto_approve_sandbox_accounts

    def initialize
      @environment = DEVELOPMENT_ENVIRONMENT
      @auto_approve_sandbox_accounts = false
    end

    def production?
      environment == PRODUCTION_ENVIRONMENT
    end

    def api_url
      production? ? PRODUCTION_API_URL : DEVELOPMENT_API_URL
    end

    def auto_approve_sandbox_accounts?
      !production? && auto_approve_sandbox_accounts
    end

    def validate!
      fail Errors::ConfigurationError unless partner_id && partner_username && partner_api_password
    end
  end
end
