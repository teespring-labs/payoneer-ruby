module Payoneer
  class PayoutStatus
    PAYMENT_STATUS_METHOD_NAME = 'GetPaymentStatus'

    def self.payout_status(payee_id:, payment_id:)
      payoneer_params = {
        p4: payee_id,
        p5: payment_id,
      }

      response = Payoneer.make_api_request(PAYMENT_STATUS_METHOD_NAME, payoneer_params)

      Response.new(response['Status'], response['Description'])
    end
  end
end
