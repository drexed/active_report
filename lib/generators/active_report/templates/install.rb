# frozen_string_literal: true

ActiveReport.configure do |config|
  config.csv_force_encoding = true
  config.csv_options = { encoding: 'UTF-8' }
end
