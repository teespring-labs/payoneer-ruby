require 'spec_helper'

describe Payoneer::Configuration do
  let(:config) { described_class.new }

  describe 'default configuration' do
    it 'defaults to development' do
      expect(config.environment).to eq('development')
    end
  end

  describe '#api_url' do
    it 'returns the production url when the environment is production' do
      config.environment = 'production'

      expect(config.api_url).to eq described_class::PRODUCTION_API_URL
    end

    it 'returns the development url when the environment is production' do
      config.environment = 'development'

      expect(config.api_url).to eq described_class::DEVELOPMENT_API_URL
    end
  end

  describe '#validate!' do
    it 'fails if the partner_id is not specified' do
      config.partner_username = 'user'
      config.partner_api_password = 'pass'

      expect{ config.validate! }.to raise_error(Payoneer::Errors::ConfigurationError)
    end

    it 'fails if the partner_username is not specified' do
      config.partner_id = 'id'
      config.partner_api_password = 'pass'

      expect{ config.validate! }.to raise_error(Payoneer::Errors::ConfigurationError)
    end

    it 'fails if the partner_api_password is not specified' do
      config.partner_id = 'id'
      config.partner_username = 'user'

      expect{ config.validate! }.to raise_error(Payoneer::Errors::ConfigurationError)
    end

    it 'validates if all the vars are specified' do
      config.partner_id = 'id'
      config.partner_username = 'user'
      config.partner_api_password = 'id'

      expect(config.validate!).to eq nil
    end
  end
end
