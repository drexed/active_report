# frozen_string_literal: true

require 'json'

module ActiveReport
  class Record < ActiveReport::Base

    attr_accessor :datum, :model, :only, :except, :headers, :options

    def initialize(datum, model: nil, only: nil, except: nil, headers: nil, options: {})
      @datum = datum
      @except = except
      @headers = headers
      @model = model
      @only = only
      @options = duplicate_options.merge!(options)
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

      @only = munge(@only).map(&:to_s)
      @except = munge(@except).map(&:to_s)

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
      @only = munge(@only)
      @except = munge(@except)

      @datum.lazy.each do |data|
        params = {}

        data.lazy.each do |key, value|
          key = key.to_s.downcase.tr(' ', '_').tr('-', '_').to_sym
          params.store(key, value)
        end

        filter(params)
        params.delete(:id)
        @model.create(params)
      end
    end

  end
end
