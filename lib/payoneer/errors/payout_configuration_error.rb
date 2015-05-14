module Payoneer
  module Errors
    class PayoutConfigurationError < StandardError
      def initialize
        super 'Payouts require a program_id to be configured. Please add your program_id to your configuration.'
      end
    end
  end
end
