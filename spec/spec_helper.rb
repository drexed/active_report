require "coveralls"
Coveralls.wear!

require "active_record"
require "active_support"
require "active_report"
require "pathname"
require "database_cleaner"

module Rails
  def self.env
    "test"
  end
end

spec_support_path = Pathname.new(File.expand_path('../spec/support', File.dirname(__FILE__)))

ActiveRecord::Base.configurations = YAML::load_file(spec_support_path.join('database.yml'))
ActiveRecord::Base.establish_connection

load(spec_support_path.join('schema.rb')) if File.exist?(spec_support_path.join('schema.rb'))

Dir.glob(spec_support_path.join('*.rb'))
   .each { |f| autoload(File.basename(f).chomp('.rb').camelcase.intern, f) }
   .each { |f| require(f) }

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) { DatabaseCleaner.start }
  config.after(:each)  { DatabaseCleaner.clean }
end