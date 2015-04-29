require 'spec_helper'

describe Payoneer::Payee do
  describe '.signup_url' do
    context 'when Payoneer successfully returns a signup url' do
      let(:signup_url) { 'http://www.payoneer.com/signupurl' }

      before do
        allow(Payoneer).to receive(:make_api_request) { signup_url }
      end

      it 'returns the signup url' do
        expect(described_class.signup_url('payee123')).to eq signup_url
      end
    end

    context 'when Payoneer returns an error response' do
      let(:error_response) {
        <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
        <PayoneerResponse>
          <Description>Field format is invalid or is not supported</Description>
          <Code>001</Code>
        </PayoneerResponse>
        XML
      }

      before do
        allow(Payoneer).to receive(:make_api_request) { error_response }
      end

      it 'raises a BadResponseStatusError' do
        expect{ described_class.signup_url('payee123', redirect_time: 'notatime') }.to raise_error(Payoneer::BadResponseStatusError)
      end
    end
  end
end
