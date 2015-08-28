require 'spec_helper'

describe Payoneer::Payee do
  describe '.signup_url' do
    context 'when Payoneer successfully returns a signup url' do
      it 'returns a success response with the signup url' do
        signup_url = 'http://www.payoneer.com/signupurl'
        successful_response = { "Token" => signup_url }
        payee_id = 'payee123'
        redirect_url = 'redirect'
        redirect_time = 'quarter-til'
        return_xml = true

        expect(Payoneer).to receive(:make_api_request).
          with('GetToken', {p4: payee_id, p6: redirect_url, p8: redirect_time, p9: false, p10: return_xml}).
          and_return(successful_response)

        expected_response = Payoneer::Response.new('000', signup_url)
        actual_response = described_class.signup_url(
          payee_id,
          redirect_url: redirect_url,
          redirect_time: redirect_time,
        )

        expect(actual_response).to eq(expected_response)
      end

      it 'passes the "auto_approve_sandbox_accounts" value as "p9" to auto-approve accounts' do
        allow(Payoneer).to receive(:configuration).and_return(double(auto_approve_sandbox_accounts?: true))

        expect(Payoneer).to receive(:make_api_request).
          with('GetToken', hash_including(p9: true)).
          and_return({"Token" => ""})

        described_class.signup_url('payee123')
      end
    end

    context 'when Payoneer returns an error response' do
      let(:error_code) { '001' }
      let(:error_description) { 'Field format is invalid or is not supported' }
      let(:error_response) {
        {
          "Description" => error_description,
          "Code" => error_code,
        }
      }

      before do
        allow(Payoneer).to receive(:make_api_request) { error_response }
      end

      it 'raises a BadResponseStatusError' do
        error_response = Payoneer::Response.new(error_code, error_description)

        expect(described_class.signup_url('payee123')).to eq(error_response)
        expect(error_response).to_not be_ok
      end
    end
  end
  describe '.details' do
    context 'when Payoneer successfully returns payee details' do
      it 'returns a success response with a hash of the payee details' do
        payee_details = {
          "FirstName" => "John",
          "LastName" => "Doe",
          "Email" => "john.doe@example.com",
          "Address1" => "123 Some Street",
          "Address2" => nil,
          "City" => "Some Place",
          "State" => nil,
          "Zip" => "H0H 0H0",
          "Country" => "CA",
          "Phone" => nil,
          "Mobile" => "18005551212",
          "PayeeStatus" => "Active",
          "PayOutMethod" => "Prepaid Card",
          "Cards" =>
            {
              "Card" => {
                "CardID" => "5549859462922457",
                "ActivationStatus" => "Card Issued, Not Activated",
                "CardShipDate" => "08/31/2015",
                "CardStatus" => "Active"
              }
          },
          "RegDate" => "8/27/2015 11:41:39 PM"
        }
        successful_response = { "Payee" => payee_details }
        payee_id = 'payee123'

        expect(Payoneer).to receive(:make_api_request).
          with('GetPayeeDetails', { p4: payee_id }).
          and_return(successful_response)

        expected_response = Payoneer::Response.new('000', payee_details)
        actual_response = described_class.details(payee_id)

        expect(actual_response).to eq(expected_response)
      end
    end

    context 'when Payoneer returns an error response for an unknown payee' do
      let(:error_code) { '002' }
      let(:error_description) { 'Payee does not exist' }
      let(:error_response) {
        {
          "Description" => error_description,
          "Code" => error_code,
        }
      }

      before do
        allow(Payoneer).to receive(:make_api_request) { error_response }
      end

      it 'raises a BadResponseStatusError' do
        error_response = Payoneer::Response.new(error_code, error_description)

        expect(described_class.details('payee-unknown')).to eq(error_response)
        expect(error_response).to_not be_ok
      end
    end
  end
end
