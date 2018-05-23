# frozen_string_literal: true

class ActiveReport::Hash < ActiveReport::Base

  def export
    @datum = munge(@datum)
    @headers = (@headers || filter_humanize_keys(@datum))

    if @stream == true
      Enumerator.new do |csv|
        csv << CSV.generate_line(@headers)
        @datum.each { |row| csv << CSV.generate_line(filter_values(row)) }
      end
    else
      CSV.generate(@options) do |csv|
        csv << @headers
        @datum.each { |row| csv << filter_values(row) }
      end
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
        @headers.each_with_index { |header, idx| subdata[header.to_s] = data[idx] }
        filter(subdata)
        array.push(subdata)
      end

      line += 1
    end

    array = array.first if array.size == 1
    metatransform(array)
  end

end
