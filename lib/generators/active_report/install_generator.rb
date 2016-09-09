require 'rails/generators'

class ActiveReport::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    copy_file('install.rb', 'config/initializers/active_report.rb')
  end

end
