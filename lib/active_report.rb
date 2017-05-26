require 'csv'

%w[version settings base array hash record].each do |file_name|
  require "active_report/#{file_name}"
end

require 'generators/active_report/install_generator'
