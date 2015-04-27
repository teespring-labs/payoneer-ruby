require 'spec_helper'

describe Payoneer::System do
  describe '.status' do
    let(:parsed_response) {
      {
        'Status' => '000',
        'Description' => 'All good',
      }
    }

    let(:response) { Payoneer::Response.new('000', 'All good') }

    before do
      allow(Payoneer).to receive(:make_api_request).with('Echo') { parsed_response }
    end

    it 'returns a ResponseStatus object from the Payoneer response' do
      expect(described_class.status).to eq response
    end
  end
end
