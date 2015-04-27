require 'spec_helper'

describe Payoneer::Response do
  describe '#ok?' do
    let(:ok_response_status) { described_class.new('000', 'good') }
    let(:bad_response_status) { described_class.new('001', 'bad') }

    it 'returns true if the status code is the ok status code' do
      expect(ok_response_status.ok?).to eq true
    end

    it 'returns false if the status code is not the ok status code' do
      expect(bad_response_status.ok?).to eq false
    end
  end
end
