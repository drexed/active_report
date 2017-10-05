# frozen_string_literal: true

class ActiveReport::Base

  @@evaluate = false

  def self.evaluate(value = true)
    @@evaluate = value
    self
  end

  private

  def duplicate_options
    ActiveReport.configuration.options.dup
  end

  # rubocop:disable Performance/StringReplacement
  def encode_to_utf8(line)
    line.map do |chr|
      next if chr.nil?
      chr.gsub!(/"/, '')
      chr.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end
  end
  # rubocop:enable Performance/StringReplacement

  def evaluate?
    value = @@evaluate
    @@evaluate = false
    value
  end










  def filter(object)
    if @only.empty?
      return if @except.empty?
      object.delete_if { |key, _| @except.include?(key) }
    else
      object.keep_if { |key, _| @only.include?(key) }
    end
  end

  def filter_first(object)
    if @only.empty?
      return if @except.empty?
      object.first.delete_if { |key, _| @except.include?(key) }
    else
      object.first.keep_if { |key, _| @only.include?(key) }
    end
  end









  def force_encoding?
    ActiveReport.configuration.force_encoding
  end







  def humanize(object)
    object.to_s.tr('_', ' ').capitalize
  end

  def merge(object)
    [].push(object).compact
  end







  # rubocop:disable Security/Eval, Lint/RescueException
  def metaform(value)
    value.nil? ? value : eval(value)
  rescue Exception
    value
  end
  # rubocop:enable Security/Eval, Lint/RescueException

  def metaform_array(datum)
    datum.map { |val| metaform(val) }
  end

  def metaform_hash(datum)
    datum.lazy.each { |key, val| datum[key] = metaform(val) }
  end

  def metamorph_array(datum)
    case datum.first.class.name
    when 'Array' then datum.map { |arr| metaform_array(arr) }
    when 'Hash' then datum.map { |hsh| metaform_hash(hsh) }
    else metaform_array(datum)
    end
  end

  def metamorph(datum)
    case datum.class.name
    when 'Array' then metamorph_array(datum)
    when 'Hash' then metaform_hash(datum)
    else metaform(datum)
    end
  end





  def metatransform(datum)
    return if datum.empty?
    evaluate? ? metamorph(datum) : datum
  end





  def munge(datum)
    datum.is_a?(Array) ? datum : merge(datum)
  end

  def munge_first(datum)
    datum.first.is_a?(Array) ? datum : merge(datum)
  end

















  def filter_values(datum)
    array = []
    (filter(datum) || datum).each_value { |val| array << val }
    array
  end

  def filter_humanize_keys(datum)
    array = []
    (filter_first(datum) || datum.first).each_key { |key| array << humanize(key) }
    array
  end

end
