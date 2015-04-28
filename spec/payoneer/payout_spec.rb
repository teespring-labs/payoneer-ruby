require 'spec_helper'

describe Payoneer::Payout do
  describe '.create' do
    let(:params) {
      {
        program_id: '1234',
        payee_id: 'payee123',
        payment_id: 'payment1',
        amount: 5,
        description: 'a payout',
        payment_date: Time.parse('2015-4-30'),
      }
    }

    let(:payoneer_params) {
      {
        p4: '1234',
        p5: 'payment1',
        p6: 'payee123',
        p7: '5.00',
        p8: 'a payout',
        p9: '04/30/2015',
        Currency: 'USD',
      }
    }

    context 'when a payout is successfully created' do
      let(:success_response) {
        <<-XML
          <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
          <PerformPayoutPayment>
            <Description>Processed Successfully</Description>
            <PaymentID>irrelevant_payment_id</PaymentID>
            <Status>000</Status>
            <PayoneerID>irrelevant_payoneer_id</PayoneerID>
          </PerformPayoutPayment>
        XML
      }

      it 'returns nil' do
        expect(Payoneer).to receive(:make_api_request).with('PerformPayoutPayment', payoneer_params) { success_response }
        expect(described_class.create(params)).to eq nil
      end
    end

    context 'when the payout creation fails' do
      let(:error_response) {
        <<-XML
          <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
          <PerformPayoutPayment>
            <Description>Insufficient funds</Description>
            <PaymentID></PaymentID>
            <Status>003</Status>
            <PayoneerID></PayoneerID>
          </PerformPayoutPayment>
        XML
      }

      it 'raises a BadResponseStatusError' do
        expect(Payoneer).to receive(:make_api_request).with('PerformPayoutPayment', payoneer_params) { error_response }
        expect{ described_class.create(params) }.to raise_error(Payoneer::BadResponseStatusError)
      end
    end
  end
end
