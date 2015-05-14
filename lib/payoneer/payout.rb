module Payoneer
  class Payout
    CREATE_PAYOUT_API_METHOD_NAME = 'PerformPayoutPayment'

    def self.create(payment_id:, payee_id:, amount:, description:, payment_date: Time.now, currency: 'USD')
      fail Errors::PayoutConfigurationError unless Payoneer.configuration.program_id.present?

      payoneer_params = {
        p4: Payoneer.configuration.program_id,
        p5: payment_id,
        p6: payee_id,
        p7: '%.2f' % amount,
        p8: description,
        p9: payment_date.strftime('%m/%d/%Y %H:%M:%S'),
        Currency: currency,
      }

      response = Payoneer.make_api_request(CREATE_PAYOUT_API_METHOD_NAME, payoneer_params)

      Response.new(response['Status'], response['Description'])
    end
  end
end
