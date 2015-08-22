# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_report/version'

Gem::Specification.new do |spec|
  spec.name          = "active_report"
  spec.version       = ActiveReport::VERSION
  spec.authors       = ["Juan Gomez"]
  spec.email         = ["j.gomez@drexed.com"]

  spec.summary       = %q{Gem for exporting/importing ruby objects to flat files vice versa.}
  spec.description   = %q{Export or import data from multiple input formats such as arrays, hashes, and active record or vice versa.}
  spec.homepage      = "https://github.com/drexed/active_report"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "active_object"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
end