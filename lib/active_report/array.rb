# frozen_string_literal: true

module ActiveReport
  class Array < ActiveReport::Base

    attr_accessor :datum, :headers, :options

    def initialize(datum, headers: nil, options: {})
      @datum = datum
      @headers = headers
      @options = duplicate_options.merge!(options)
    end

    def self.export(datum, headers: nil, options: {})
      klass = new(datum, headers: headers, options: options)
      klass.export
    end

    def self.import(datum, headers: nil, options: {})
      klass = new(datum, headers: headers, options: options)
      klass.import
    end

    def export
      @datum = munge_first(@datum)

      CSV.generate(@options) do |csv|
        csv << @headers unless @headers.nil?

        @datum.lazy.each { |cell| csv << cell }
      end
    end

    def import
      datum = merge(@headers)

      CSV.foreach(@datum, @options) do |data|
        data = encode_to_utf8(data) if force_encoding?
        datum.push(data)
      end

      datum = datum.flatten if datum.size < 2
      metatransform(datum)
    end

  end
end
