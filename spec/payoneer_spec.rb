require 'spec_helper'

describe Payoneer do
  it 'has a version number' do
    expect(Payoneer::VERSION).not_to be nil
  end

  describe '.make_api_request' do
    before do
      Payoneer.configure do |config|
        config.partner_username = 'user'
        config.partner_api_password = 'pass'
        config.partner_id = 1
        config.currency = Payoneer::DEFAULT_CURRENCY

        [Payoneer::DEFAULT_CURRENCY, config]
      end
    end

    context 'when the response is unsuccessful' do
      before do
        allow(RestClient).to receive(:post) { double(code: 500, body: '') }
      end

      it 'raises and UnexpectedResponseError if a response code other than 200 is returned' do
        expect{ Payoneer.make_api_request('PayoneerMethod', {Currency: Payoneer::DEFAULT_CURRENCY}) }.to raise_error(Payoneer::Errors::UnexpectedResponseError)
      end
    end

    context 'when the response is successful' do
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

      let(:expected_hash_from_xml_response) {
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
        expect(Payoneer.make_api_request('PayoneerMethod')).to eq expected_hash_from_xml_response
      end
    end

    context 'when Payoneer is not configured' do
      it 'raises a ConfigurationError if not all config values are set' do
        Payoneer.configure do |config|
          config.partner_username = nil
        end

        expect{ Payoneer.make_api_request('method') }.to raise_error(Payoneer::Errors::ConfigurationError)
      end
    end
  end

  describe '.configure' do
    before do
      Payoneer.configure do |config|
        config.partner_username = 'the_user_name'
        config.currency = Payoneer::DEFAULT_CURRENCY

        [Payoneer::DEFAULT_CURRENCY, config]
      end
    end

    it 'yields the Payoneer configuration for a block to instantiate' do
      expect(Payoneer.configuration_by_currency(Payoneer::DEFAULT_CURRENCY).partner_username).to eq 'the_user_name'
    end

    it 'yields the new configuration for multiple calls' do
      Payoneer.configure do |config|
        config.partner_id = 3
        config.currency = Payoneer::DEFAULT_CURRENCY

        [Payoneer::DEFAULT_CURRENCY, config]
      end

      expect(Payoneer.configuration_by_currency(Payoneer::DEFAULT_CURRENCY).partner_username).to be_nil
      expect(Payoneer.configuration_by_currency(Payoneer::DEFAULT_CURRENCY).partner_id).to eq 3
    end
  end

  describe 'multi .configure' do
    before do
      configs = [Payoneer::DEFAULT_CURRENCY, 'EUR'].each_with_object({}) do |currency, hash|
        config = Payoneer::Configuration.new
        config.currency = currency
        hash[currency] = config
      end

      Payoneer.configure(configs)
    end

    it 'returns correct config' do
      expect(Payoneer.configuration_by_currency(nil).currency).to eq(Payoneer::DEFAULT_CURRENCY)
      expect(Payoneer.configuration_by_currency('EUR').currency).to eq('EUR')
    end
  end
end
