# frozen_string_literal: true

class ActiveReport::Hash < ActiveReport::Base

  def export
    @data = munge(@data)
    @opts[:headers] = (@opts[:headers] || filter_humanize_keys(@data))

    @opts[:stream] ? export_stream : export_csv
  end

  def import
    array = []

    CSV.foreach(@data, @opts[:options]).with_index do |data, i|
      data = encode_to_utf8(data) if csv_force_encoding?

      if @opts[:headers].nil? && i.zero?
        @opts[:headers] = data
      else
        subdata = {}
        @opts[:headers].each_with_index { |header, idx| subdata[header.to_s] = data[idx] }
        filter(subdata)
        array.push(subdata)
      end
    end

    array = array.first if array.size == 1
    metatransform(array)
  end

  private

  def export_csv
    CSV.generate(@opts[:options]) do |csv|
      csv << @opts[:headers]

      @data.each { |row| csv << filter_values(row) }
    end
  end

  def export_stream
    Enumerator.new do |csv|
      csv << CSV.generate_line(@opts[:headers])

      @data.each { |row| csv << CSV.generate_line(filter_values(row)) }
    end
  end

end
