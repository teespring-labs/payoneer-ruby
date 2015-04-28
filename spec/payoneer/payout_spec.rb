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
        payment_date: Time.parse('2015-4-30 03:33:44'),
      }
    }

    let(:payoneer_params) {
      {
        p4: '1234',
        p5: 'payment1',
        p6: 'payee123',
        p7: '5.00',
        p8: 'a payout',
        p9: '04/30/2015 03:33:44',
        Currency: 'USD',
      }
    }

    context 'when a payout is successfully created' do
      let(:success_response) {
        {
          "Description" => "Processed Successfully",
          "PaymentID" => "irrelevant_payment_id",
          "Status" => "000",
          "PayoneerID" => "irrelevant_payoneer_id",
        }
      }

      it 'returns a success response' do
        expect(Payoneer).to receive(:make_api_request).with('PerformPayoutPayment', payoneer_params) { success_response }

        expected_response = Payoneer::Response.new('000', 'Processed Successfully')
        actual_response = described_class.create(params)

        expect(actual_response).to eq(expected_response)
      end
    end

    context 'when the payout creation fails' do
      let(:error_response) {
        {
          "Description" => "Insufficient funds",
          "PaymentID" => nil,
          "Status" => "003",
          "PayoneerID" => nil,
        }
      }

      it 'returns an error response' do
        expect(Payoneer).to receive(:make_api_request).with('PerformPayoutPayment', payoneer_params) { error_response }

        expected_response = Payoneer::Response.new('003', 'Insufficient funds')
        actual_response = described_class.create(params)

        expect(actual_response).to eq(expected_response)
      end
    end
  end
end
