# frozen_string_literal: true

ActiveReport::Settings.configure do |config|
  config.force_encoding = true
  config.options = { encoding: 'UTF-8' }
end
