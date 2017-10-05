# frozen_string_literal: true

module ActiveReport
  class Array < ActiveReport::Base

    attr_accessor :data, :headers, :options

    def initialize(data, headers: nil, options: {})
      @data = data
      @headers = headers
      @options = csv_options.merge(options)
    end

    def self.export(data, headers: nil, options: {})
      klass = new(data, headers: headers, options: options)
      klass.export
    end

    def self.import(data, headers: nil, options: {})
      klass = new(data, headers: headers, options: options)
      klass.import
    end

    def export
      @data = munge_first(@data)

      CSV.generate(@options) do |csv|
        csv << @headers unless @headers.nil?
        @data.lazy.each { |cell| csv << cell }
      end
    end

    def import
      array = merge(@headers)

      CSV.foreach(@data, @options) do |row|
        row = encode_to_utf8(row) if csv_force_encoding?
        array.push(row)
      end

      array = array.flatten if array.size < 2
      metatransform(array)
    end

  end
end
