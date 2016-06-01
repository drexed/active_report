class ActiveReport::Array < ActiveReport::Base

  attr_accessor :datum, :headers, :options

  def initialize(datum, headers: nil, options: {})
    @datum, @headers = datum, headers
    @options = duplicate_options.merge!(options)
  end

  def self.export(datum, headers: nil, options: {})
    new(datum, headers: headers, options: options).export
  end

  def self.import(datum, headers: nil, options: {})
    new(datum, headers: headers, options: options).import
  end

  def export
    @datum = munge_first(@datum)

    CSV.generate(@options) do |csv|
      csv << @headers unless @headers.nil?
      @datum.lazy.each { |data| csv << data }
    end
  end

  def import
    datum = merge(@headers)

    CSV.foreach(@datum, @options) do |data|
      data = encode_to_utf8(data) if force_encoding?
      datum.push(data)
    end

    datum.size < 2 ? datum.flatten : datum
  end

end
