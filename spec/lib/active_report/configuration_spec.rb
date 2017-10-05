# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Configuration do
  after(:all) do
    ActiveReport.configure do |config|
      config.force_encoding = true
      config.options = { encoding: 'UTF-8' }
    end
  end

  describe '#configure' do
    it 'to be "91 test" for force_encoding' do
      ActiveReport.configuration.force_encoding = '91 test'

      expect(ActiveReport.configuration.force_encoding).to eq('91 test')
    end

    it 'to be "19 test" for options' do
      ActiveReport.configuration.options = '19 test'

      expect(ActiveReport.configuration.options).to eq('19 test')
    end
  end

end
