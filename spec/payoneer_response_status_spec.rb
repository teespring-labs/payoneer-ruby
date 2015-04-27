require 'spec_helper'

describe Payoneer::ResponseStatus do
  describe '#ok?' do
    let(:ok_status_code) { '000' }
    let(:ok_response_status) { described_class.new(ok_status_code, 'good') }
    let(:bad_response_status) { described_class.new('001', 'bad') }

    it 'returns true if the status code is the ok status code' do
      expect(ok_response_status.ok?).to eq true
    end

    it 'returns false if the status code is not the ok status code' do
      expect(bad_response_status.ok?).to eq false
    end
  end

  context 'from response' do
    let(:response_status) { described_class.new('000', 'all good') }

    describe '.from_parsed_response' do
      let(:response_hash) {
        {
          'Code' => '000',
          'Description' => 'all good',
        }
      }
      let(:alternate_response_hash) {
        {
          'Status' => '000',
          'Description' => 'all good',
        }
      }

      it 'initializes a new ResponseStatus from a response hash' do
        expect(described_class.from_parsed_response(response_hash)).to eq response_status
      end

      it 'works with a reponse hash with a code key of "Status"' do
        expect(described_class.from_parsed_response(alternate_response_hash)).to eq response_status
      end
    end

    describe '.from_response' do
      let(:xml_response) {
        <<-XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
        <PerformPayoutPayment>
          <Description>all good</Description>
          <Status>000</Status>
        </PerformPayoutPayment>
        XML
      }

      it 'initializes a new ResponseStatus from an xml response string' do
        expect(described_class.from_response(xml_response)).to eq response_status
      end
    end
  end
end
