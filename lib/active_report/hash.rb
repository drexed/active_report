# frozen_string_literal: true

module ActiveReport
  class Hash < ActiveReport::Base

    attr_accessor :datum, :only, :except, :headers, :options

    def initialize(datum, only: nil, except: nil, headers: nil, options: {})
      @datum = datum
      @only = munge(only)
      @except = munge(except)
      @headers = headers
      @options = csv_options.merge!(options)
    end

    def self.export(datum, only: nil, except: nil, headers: nil, options: {})
      klass = new(datum, only: only, except: except, headers: headers, options: options)
      klass.export
    end

    def self.import(datum, only: nil, except: nil, headers: nil, options: {})
      klass = new(datum, only: only, except: except, headers: headers, options: options)
      klass.import
    end

    def export
      @datum = munge(@datum)

      CSV.generate(@options) do |csv|
        csv << (@headers || filter_humanize_keys(@datum))
        @datum.lazy.each { |data| csv << filter_values(data) }
      end
    end

    def import
      array = []
      line = 0

      CSV.foreach(@datum, @options) do |data|
        data = encode_to_utf8(data) if csv_force_encoding?

        if @headers.nil? && line.zero?
          @headers = data
        else
          subdata = {}
          @headers.lazy.each_with_index { |header, idx| subdata[header.to_s] = data[idx] }
          filter(subdata)
          array.push(subdata)
        end

        line += 1
      end

      array = array.first if array.size == 1
      metatransform(array)
    end

  end
end
