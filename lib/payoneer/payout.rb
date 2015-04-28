module Payoneer
  class Payout
    CREATE_PAYOUT_API_METHOD_NAME = 'PerformPayoutPayment'

    def self.create(program_id: nil, payee_id: nil, payment_id: nil, amount: nil, currency: 'USD', description: nil, payment_date: Time.now)
      payoneer_params = {
        p4: program_id,
        p5: payment_id,
        p6: payee_id,
        p7: '%.2f' % amount,
        p8: description,
        p9: payment_date.strftime('%m/%d/%Y'),
        Currency: currency,
      }

      response = Payoneer.make_api_request_parsed(CREATE_PAYOUT_API_METHOD_NAME, payoneer_params)

      status = ResponseStatus.from_parsed_response(response)

      fail BadResponseStatusError.new(status) unless status.ok?
    end
  end
end
