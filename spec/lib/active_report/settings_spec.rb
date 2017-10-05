# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Settings do

  after(:all) do
    ActiveReport::Settings.configure do |config|
      config.force_encoding = true
      config.options = { encoding: 'UTF-8' }
    end
  end

  describe '#configure' do
    it 'to be "91 test"' do
      ActiveReport::Settings.configure do |config|
        config.force_encoding = '91 test'
      end

      expect(ActiveReport::Settings.config.force_encoding).to eq('91 test')
    end

    it 'to be "19 test"' do
      ActiveReport::Settings.configure do |config|
        config.options = '19 test'
      end

      expect(ActiveReport::Settings.config.options).to eq('19 test')
    end
  end

end
