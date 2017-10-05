# frozen_string_literal: true

%w[active_record active_report pathname generator_spec database_cleaner].each do |file_name|
  require file_name
end

spec_support_path = Pathname.new(File.expand_path('../spec/support', File.dirname(__FILE__)))
spec_tmp_path = Pathname.new(File.expand_path('../spec/lib/tmp', File.dirname(__FILE__)))

ActiveRecord::Base.configurations = YAML::load_file(spec_support_path.join('config/database.yml'))
ActiveRecord::Base.establish_connection(:test)

load(spec_support_path.join('db/schema.rb'))

Dir.glob(spec_support_path.join('models/*.rb'))
   .each { |f| autoload(File.basename(f).chomp('.rb').camelcase.intern, f) }
   .each { |f| require(f) }

module LetManager
 extend RSpec::SharedContext

 let(:multi_headerless_options_path) { 'spec/support/csv/multi_headerless_options.csv' }
 let(:multi_headerless_path) { 'spec/support/csv/multi_headerless.csv' }
 let(:multi_headers_path) { 'spec/support/csv/multi_headers.csv' }
 let(:multi_options_path) { 'spec/support/csv/multi_options.csv' }
 let(:multi_except_path) { 'spec/support/csv/multi_except.csv' }
 let(:multi_only_path) { 'spec/support/csv/multi_only.csv' }
 let(:multi_all_path) { 'spec/support/csv/multi_all.csv' }
 let(:solo_headerless_options_path) { 'spec/support/csv/solo_headerless_options.csv' }
 let(:solo_headerless_path) { 'spec/support/csv/solo_headerless.csv' }
 let(:solo_headers_path) { 'spec/support/csv/solo_headers.csv' }
 let(:solo_options_path) { 'spec/support/csv/solo_options.csv' }
 let(:solo_except_path) { 'spec/support/csv/solo_except.csv' }
 let(:solo_only_path) { 'spec/support/csv/solo_only.csv' }
 let(:solo_all_path) { 'spec/support/csv/solo_all.csv' }
 let(:options) do
   { col_sep: ';' }
 end
end

RSpec.configure do |config|
  config.include LetManager

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
  config.after(:all) { FileUtils.remove_dir(spec_tmp_path) if File.directory?(spec_tmp_path) }
end
