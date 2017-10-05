# frozen_string_literal: true

require 'csv'

%w[version configuration base array hash record].each do |file_name|
  require "active_report/#{file_name}"
end

require 'generators/active_report/install_generator'
