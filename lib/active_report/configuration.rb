# frozen_string_literal: true

module ActiveReport
  class Configuration

    attr_accessor :csv_force_encoding, :csv_options, :import_adapter, :import_options

    def initialize
      @csv_force_encoding = true
      @csv_options = { encoding: 'UTF-8' }
      @import_adapter = 'mysql2_adapter'
      @import_options = { validate: false, on_duplicate_key_ignore: true }
    end

  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield(configuration)
  end

end
