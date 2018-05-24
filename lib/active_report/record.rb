# frozen_string_literal: true

require 'activerecord-import'
require 'activerecord-import/base'
require "activerecord-import/active_record/adapters/#{ActiveReport.configuration.import_adapter}"
require 'json'

class ActiveReport::Record < ActiveReport::Base

  def export
    %i[except only].each { |key| @opts[key] = @opts[key].map(&:to_s) }

    if active_record_table_class?(@data)
      @opts[:headers] = (@opts[:headers] || humanize_values(@data.column_names))

      @opts[:stream] ? export_stream : export_csv
    else
      @data = if @data.is_a?(ActiveRecord::Relation)
                JSON.parse(@data.to_json).flatten
              else
                merge(@data.attributes)
              end

      ActiveReport::Hash.export(@data, @opts)
    end
  end

  def import
    if active_record_table_object?(@opts[:model])
      raise ArgumentError,
            'Model must be an ActiveRecord::Base object.'
    end

    @data = ActiveReport::Hash.import(@data, headers: @opts[:headers], options: @opts[:options])
    @data = munge(@data)

    records = []
    @data.each do |data|
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

  private

  def export_csv
    CSV.generate(@opts[:options]) do |csv|
      csv << @opts[:headers]

      @data.find_each(start: @opts[:start],
                      finish: @opts[:finish],
                      batch_size: @opts[:batch_size],
                      error_on_ignore: @opts[:error_on_ignore]) do |row|
        csv << filter_values(row.attributes)
      end
    end
  end

  def export_stream
    Enumerator.new do |csv|
      csv << CSV.generate_line(@opts[:headers])

      @data.find_each(start: @opts[:start],
                      finish: @opts[:finish],
                      batch_size: @opts[:batch_size],
                      error_on_ignore: @opts[:error_on_ignore]) do |row|
        csv << CSV.generate_line(filter_values(row.attributes))
      end
    end
  end

end
