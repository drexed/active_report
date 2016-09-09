require 'csv'
require 'active_report/version'
require 'active_report/configuration'

module ActiveReport

  class << self
    attr_accessor :configuration
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

require 'active_report/base'
require 'active_report/array'
require 'active_report/hash'
require 'active_report/record'

require 'generators/active_report/install_generator'
