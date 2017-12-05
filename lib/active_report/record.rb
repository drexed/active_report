# frozen_string_literal: true

require 'activerecord-import'
require 'activerecord-import/base'
require "activerecord-import/active_record/adapters/#{ActiveReport.configuration.import_adapter}"
require 'json'

class ActiveReport::Record < ActiveReport::Base

  attr_accessor :datum, :model, :only, :except, :headers, :options

  def initialize(datum, model: nil, only: nil, except: nil, headers: nil, options: {})
    @datum = datum
    @model = model
    @only = munge(only)
    @except = munge(except)
    @headers = headers
    @options = csv_options.merge(options)
  end

  def self.export(datum, only: nil, except: nil, headers: nil, options: {})
    klass = new(datum, only: only, except: except, headers: headers, options: options)
    klass.export
  end

  def self.import(datum, only: nil, except: nil, headers: nil, options: {}, model: nil)
    klass = new(datum, only: only, except: except, headers: headers, options: options, model: model)
    klass.import
  end

  def export
    @datum = if @datum.is_a?(ActiveRecord::Relation)
               JSON.parse(@datum.to_json).flatten
             else
               merge(@datum.attributes)
             end

    @only.map!(&:to_s)
    @except.map!(&:to_s)

    CSV.generate(@options) do |csv|
      csv << (@headers || filter_humanize_keys(@datum))
      @datum.lazy.each { |data| csv << filter_values(data) }
    end
  end

  def import
    if @model.nil? || (@model.superclass != ActiveRecord::Base)
      raise ArgumentError,
            'Model must be an ActiveRecord::Base object.'
    end

    @datum = ActiveReport::Hash.import(@datum, headers: @headers, options: @options)
    @datum = munge(@datum)

    records = []
    @datum.lazy.each do |data|
      params = {}

      data.lazy.each do |key, value|
        key = key.to_s.downcase.gsub(/ |-/, '_').to_sym
        params[key] = value
      end

      filter(params)
      params.delete(:id)
      records << params
    end

    @model.import(records, import_options)
  end

end
