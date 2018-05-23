# frozen_string_literal: true

class ActiveReport::Array < ActiveReport::Base

  def export
    @data = munge_first(@data)
    @data = @data.unshift(@opts[:headers]) unless @opts[:headers].nil?

    @opts[:stream] ? export_stream : export_csv
  end

  def import
    array = merge(@opts[:headers])

    CSV.foreach(@data, @opts[:options]) do |row|
      row = encode_to_utf8(row) if csv_force_encoding?
      array.push(row)
    end

    array = array.flatten if array.size < 2
    metatransform(array)
  end

  private

  def export_csv
    CSV.generate(@opts[:options]) do |csv|
      @data.each { |row| csv << row }
    end
  end

  def export_stream
    Enumerator.new do |csv|
      @data.each { |row| csv << CSV.generate_line(row) }
    end
  end

end
