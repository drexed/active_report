# frozen_string_literal: true

# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_report/version'

Gem::Specification.new do |spec|
  spec.name = 'active_report'
  spec.version = ActiveReport::VERSION
  spec.authors = ['Juan Gomez']
  spec.email = ['j.gomez@drexed.com']

  spec.summary = 'Gem for exporting/importing ruby objects to flat files vice versa.'
  # rubocop:disable Metrics/LineLength
  spec.description = 'Export or import data from multiple input formats such as arrays, hashes, and active record or vice versa.'
  # rubocop:enable Metrics/LineLength
  spec.homepage = 'http://drexed.github.io/active_report'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib support]

  spec.add_runtime_dependency 'activerecord'
  spec.add_runtime_dependency 'dry-configurable'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'fasterer'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
end
