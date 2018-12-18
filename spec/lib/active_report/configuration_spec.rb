# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Configuration do
  after(:all) do
    ActiveReport.configure do |config|
      config.csv_force_encoding = true
      config.csv_options = { external_encoding: 'ISO-8859-1', internal_encoding: 'UTF-8' }
      config.import_adapter = 'mysql2_adapter'
      config.import_options = { validate: false, on_duplicate_key_ignore: true }
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

    it 'to be "19 test" for import_adapter' do
      ActiveReport.configuration.import_adapter = '19 test'

      expect(ActiveReport.configuration.import_adapter).to eq('19 test')
    end

    it 'to be "19 test" for import_options' do
      ActiveReport.configuration.import_options = '19 test'

      expect(ActiveReport.configuration.import_options).to eq('19 test')
    end
  end

end
