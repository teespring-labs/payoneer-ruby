require 'spec_helper'

describe Payoneer::Configuration do
  let(:config) { described_class.new }

  describe 'default configuration' do
    it 'defaults to development' do
      expect(config.environment).to eq('development')
      expect(config.production?).to be(false)
    end
  end

  describe '#auto_approve_sandbox_accounts?' do
    it 'is false if not in development' do
      config.environment = 'production'
      config.auto_approve_sandbox_accounts = true

      expect(config.auto_approve_sandbox_accounts?).to be(false)
    end

    it 'is false if flag is not set and in development' do
      config.environment = 'development'

      expect(config.auto_approve_sandbox_accounts?).to be(false)
    end

    it 'is false if flag is false' do
      config.environment = 'development'
      config.auto_approve_sandbox_accounts = false

      expect(config.auto_approve_sandbox_accounts?).to be(false)
    end

    it 'is true if flag is true and in development' do
      config.environment = 'development'
      config.auto_approve_sandbox_accounts = true

      expect(config.auto_approve_sandbox_accounts?).to be(true)
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
      config.currency = 'USD'

      expect(config.validate!).to eq nil
    end
  end
end
