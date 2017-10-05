# frozen_string_literal: true

module ActiveReport
  class Configuration

    attr_accessor :force_encoding, :options

    def initialize
      @force_encoding = true
      @options = { encoding: 'UTF-8' }
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
