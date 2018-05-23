# frozen_string_literal: true

require 'activerecord-import'
require 'activerecord-import/base'
require "activerecord-import/active_record/adapters/#{ActiveReport.configuration.import_adapter}"
require 'json'

class ActiveReport::Record < ActiveReport::Base

  def self.dump(datum, opts = {})
    klass = new(datum, opts)
    klass.dump
  end

  def dump
    @opts[:headers] = (@opts[:headers] || @datum.column_names.map { |col| humanize(col) })

    if @opts[:stream] == true
      Enumerator.new do |csv|
        csv << CSV.generate_line(@opts[:headers])

        @datum.find_each do |row|
          csv << CSV.generate_line(filter_values(row.attributes))
        end
      end
    else
      CSV.generate(@opts[:options]) do |csv|
        csv << @opts[:headers]

        @datum.find_each do |row|
          csv << filter_values(row.attributes)
        end
      end
    end
  end

  def export
    @datum = if @datum.is_a?(ActiveRecord::Relation)
               JSON.parse(@datum.to_json).flatten
             else
               merge(@datum.attributes)
             end

    %i[except only].each { |key| @opts[key] = @opts[key].map(&:to_s) }

    ActiveReport::Hash.export(@datum, @opts)
  end

  def import
    if @opts[:model].nil? || (@opts[:model].superclass != ActiveRecord::Base)
      raise ArgumentError,
            'Model must be an ActiveRecord::Base object.'
    end

    @datum = ActiveReport::Hash.import(@datum, headers: @opts[:headers], options: @opts[:options])
    @datum = munge(@datum)

    records = []
    @datum.each do |data|
      params = {}

      data.each do |key, value|
        key = key.to_s.downcase.gsub(/ |-/, '_').to_sym
        params[key] = value
      end

      filter(params)
      params.delete(:id)
      records << params
    end

    @opts[:model].import(records, import_options)
  end

end
