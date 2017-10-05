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

  let(:only_except_1) do
    ['Name']
  end
  let(:only_except_2) do
    ['Id', 'Name']
  end

  let(:header_type_1) do
    ['Id', 'Name', 'Speed', 'Hp', 'Crash safety rated', 'Created at']
  end
  let(:header_type_2) do
    ['No.', 'Model', 'Speed', 'Horse Power', 'Crash Safety Rated', 'Driven On']
  end

end
