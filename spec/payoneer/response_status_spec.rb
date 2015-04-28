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

  describe '.from_response' do
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
    let(:response_status) { described_class.new('000', 'all good') }

    it 'initializes a new ResponseStatus from a response hash' do
      expect(described_class.from_response(response_hash)).to eq response_status
    end

    it 'works with a reponse hash with a code key of "Status"' do
      expect(described_class.from_response(alternate_response_hash)).to eq response_status
    end
  end
end
