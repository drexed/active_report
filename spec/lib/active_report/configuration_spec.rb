# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Configuration do
  after(:all) do
    ActiveReport.configure do |config|
      config.csv_force_encoding = true
      config.csv_options = { encoding: 'UTF-8' }
    end
  end

  describe '#configure' do
    it 'to be "91 test" for csv_force_encoding' do
      ActiveReport.configuration.csv_force_encoding = '91 test'

      expect(ActiveReport.configuration.csv_force_encoding).to eq('91 test')
    end

    it 'to be "19 test" for csv_options' do
      ActiveReport.configuration.csv_options = '19 test'

      expect(ActiveReport.configuration.csv_options).to eq('19 test')
    end
  end

end
