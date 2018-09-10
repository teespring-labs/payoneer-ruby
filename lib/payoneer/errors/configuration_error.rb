module Payoneer
  module Errors
    class ConfigurationError < StandardError
      def initialize
        super 'Not all config vars were set. Payoneer requires partner_username, currency, and partner_api_password.'
      end
    end
  end
end
