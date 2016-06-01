# ActiveReport

[![Gem Version](https://badge.fury.io/rb/active_report.svg)](http://badge.fury.io/rb/active_report)
[![Build Status](https://travis-ci.org/drexed/active_report.svg?branch=master)](https://travis-ci.org/drexed/active_report)
[![Coverage Status](https://coveralls.io/repos/github/drexed/active_report/badge.svg?branch=master)](https://coveralls.io/github/drexed/active_report?branch=master)

ActiveReport is a library to export CSV's out of arrays, hashes, and records and vice versa.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "active_report"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_report

## Table of Contents

* [Configuration](#configuration)
* [Array](#array)
* [Hash](#hash)
* [Record](#record)

## Configuration

`rails g active_report:install` will generate the following `active_report.rb` file:

```ruby
# config/initalizers/active_report.rb

ActiveReport.configure do |config|
  # option = default

  config.force_encoding = true
  config.options = { encoding: "UTF-8" }
end
```

## Array

**Export:** Convert an array or array of arrays to a CSV.

**Options:**
 * headers: column titles of CSV data
 * options: CSV options to be use on generation

```ruby
@list = [
  [1, "Lorem lipsum etc...", true],
  [2, "Xorem lipsum etc...", false],
  [3, "Porem lipsum etc...", true]
]

ActiveReport::Array.export(@list)
ActiveReport::Array.export(@list, headers: ["ID", "Task", "Completed"], options: { col_sep: ";" })
```

**Import:** Convert a CSV into an array or array of arrays.

**Options:**
 * headers: column titles of array data
 * options: CSV options to be use on parsing

```ruby
ActiveReport::Array.import("sample.csv")
ActiveReport::Array.import("sample.csv", headers: ["ID", "Task", "Completed"], options: { col_sep: ";" })
```

## Hash

**Export:** Convert a hash or an array of hashes to a CSV.

**Options:**
 * only:    keys of pairs to be used on generation
 * except:  keys of pairs not to be used on generation
 * headers: column titles of CSV data
 * options: CSV options to be use on generation

```ruby
@list = [
  { id: 1, item: "Lorem lipsum etc...", completed: true},
  { id: 2, item: "Xorem lipsum etc...", completed: false},
  { id: 3, item: "Porem lipsum etc...", completed: true}
]

ActiveReport::Hash.export(@list)
ActiveReport::Hash.export(@list, only: [:id, :item], headers: ["ID", "Task"], options: { col_sep: ";" })
```

**Import:** Convert a CSV into an array of hashes.

**Options:**
 * only:    keys of pairs to be used on generation
 * except:  keys of pairs not to be used on generation
 * headers: column titles of CSV data **Required**
 * options: CSV options to be use on parsing

```ruby
ActiveReport::Hash.import("sample.csv")
ActiveReport::Hash.import("sample.csv", except: :completed, headers: ["ID", "Task"], options: { col_sep: ";" })
```

## Record

**Export:** Convert an ActiveRecord/Relation object(s) to a CSV.

**Options:**
 * only:    columns to be used on generation
 * except:  columns not to be used on generation
 * headers: column titles of CSV data
 * options: CSV options to be use on generation

```ruby
@list = [
  <# ActiveRecord::Relation Object >,
  <# ActiveRecord::Relation Object >,
  <# ActiveRecord::Relation Object >
]

ActiveReport::Record.export(@list)
ActiveReport::Record.export(@list, only: [:id, :item], headers: ["ID", "Task"], options: { col_sep: ";" })
```

**Import:** Create new database records from a CSV.

**Options:**
 * model:   model of objects being generated
 * only:    keys of pairs to be used on generation
 * except:  keys of pairs not to be used on generation
 * headers: column titles of CSV data **Required**
 * options: CSV options to be use on parsing

```ruby
ActiveReport::Record.import("sample.csv", model: User)
ActiveReport::Record.import("sample.csv", model: User, except: :completed, headers: ["ID", "Task"], options: { col_sep: ";" })
```

## Contributing

Your contribution is welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
