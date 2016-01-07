class ActiveReport::Array < ActiveReport::Base

  attr_accessor :datum, :headers, :options

  def initialize(datum, headers: nil, options: {})
    @datum   = datum
    @headers = headers
    @options = options
  end

  def self.export(datum, headers: nil, options: {})
    new(datum, headers: headers, options: options).export
  end

  def self.import(datum, headers: nil, options: {})
    new(datum, headers: headers, options: options).import
  end

  def export
    @datum = [].push(@datum).compact unless @datum.first.is_a?(Array)

    CSV.generate(@options) do |csv|
      csv << @headers unless @headers.nil?
      @datum.lazy.each { |d| csv << d }
    end
  end

  def import
    processed_datum = [].push(@headers).compact
    CSV.foreach(@datum, @options, encoding: "iso-8859-1:UTF-8") { |d| processed_datum.push(encode_to_utf8(d)) }
    processed_datum.size < 2 ? processed_datum.flatten : processed_datum
  end

end