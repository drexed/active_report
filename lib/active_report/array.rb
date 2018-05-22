# frozen_string_literal: true

class ActiveReport::Array < ActiveReport::Base

  def initialize(datum, headers: nil, options: {}, stream: false)
    @datum = datum
    @headers = headers
    @options = csv_options.merge(options)
    @stream = stream
  end

  def self.export(datum, headers: nil, options: {}, stream: false)
    klass = new(datum, headers: headers, options: options, stream: stream)
    klass.export
  end

  def self.import(datum, headers: nil, options: {})
    klass = new(datum, headers: headers, options: options)
    klass.import
  end

  def export
    @datum = munge_first(@datum)

    if @stream == true
      Enumerator.new do |csv|
        csv << @headers unless @headers.nil?
        @datum.each { |row| csv << row }
      end
    else
      CSV.generate(@options) do |csv|
        csv << @headers unless @headers.nil?
        @datum.each { |row| csv << row }
      end
    end
  end

  def import
    array = merge(@headers)

    CSV.foreach(@datum, @options) do |row|
      row = encode_to_utf8(row) if csv_force_encoding?
      array.push(row)
    end

    array = array.flatten if array.size < 2
    metatransform(array)
  end

end
