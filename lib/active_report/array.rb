# frozen_string_literal: true

class ActiveReport::Array < ActiveReport::Base

  def export
    @datum = munge_first(@datum)
    @datum = @datum.unshift(@opts[:headers]) unless @opts[:headers].nil?

    if @opts[:stream] == true
      Enumerator.new do |csv|
        @datum.each { |row| csv << CSV.generate_line(row) }
      end
    else
      CSV.generate(@opts[:options]) do |csv|
        @datum.each { |row| csv << row }
      end
    end
  end

  def import
    array = merge(@opts[:headers])

    CSV.foreach(@datum, @opts[:options]) do |row|
      row = encode_to_utf8(row) if csv_force_encoding?
      array.push(row)
    end

    array = array.flatten if array.size < 2
    metatransform(array)
  end

end
