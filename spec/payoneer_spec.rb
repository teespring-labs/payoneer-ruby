require 'spec_helper'

describe Payoneer do
  it 'has a version number' do
    expect(Payoneer::VERSION).not_to be nil
  end

  describe '.api_url' do
    it 'returns the production url when the environment is production' do
      Payoneer.environment = 'production'

      expect(Payoneer.api_url).to eq Payoneer.production_api_url
    end

    it 'returns the development url when the environment is production' do
      Payoneer.environment = 'development'

      expect(Payoneer.api_url).to eq Payoneer.development_api_url
    end
  end

  describe '.make_api_request' do
    context 'when the response is unsuccessful' do
      before do
        allow(RestClient).to receive(:post) { double(code: 500, body: '') }
      end

      it 'raises and UnexpectedResponseError if a response code other than 200 is returned' do
        expect{ Payoneer.make_api_request('PayoneerMethod') }.to raise_error(Payoneer::UnexpectedResponseError)
      end
    end

    context 'when the response is successful' do
      before do
        allow(RestClient).to receive(:post) { double(code: 200, body: 'hello') }
      end

      it 'returns the body of the response' do
        expect(Payoneer.make_api_request('PayoneerMethod')).to eq 'hello'
      end
    end
  end

  describe '.make_api_request_parsed' do
    let(:xml_response) {
      <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
      <PerformPayoutPayment>
        <Description></Description>
        <PaymentID>1</PaymentID>
        <Status>000</Status>
        <PayoneerID>1</PayoneerID>
      </PerformPayoutPayment>
      XML
    }

    let(:hash_from_xml_response) {
      {
        "Description" => nil,
        "PaymentID" => "1",
        "Status" => "000",
        "PayoneerID" => "1",
      }
    }

    before do
      allow(RestClient).to receive(:post) { double(code: 200, body: xml_response) }
    end

    it 'returns a hash from the Payoneer xml response' do
      expect(Payoneer.make_api_request_parsed('PayoneerMethod')).to eq hash_from_xml_response
    end
  end

end
