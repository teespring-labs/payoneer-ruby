require 'spec_helper'

describe Payoneer::API do
  describe '.status' do
    let(:parsed_response) {
      {
        'Status' => '000',
        'Description' => 'All good',
      }
    }

    let(:response_status) { Payoneer::ResponseStatus.new('000', 'All good') }

    before do
      allow(Payoneer).to receive(:make_api_request_parsed).with('Echo') { parsed_response }
    end

    it 'returns a ResponseStatus object from the Payoneer response' do
      expect(Payoneer::API.status).to eq response_status
    end
  end
end
