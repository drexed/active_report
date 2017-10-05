# frozen_string_literal: true

class ActiveReport::Base

  @@evaluate = false

  def self.evaluate(value = true)
    @@evaluate = value
    self
  end

  private

  def duplicate_options
    ActiveReport::Settings.config.options.dup
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
      object.delete_if { |key, _| @except.include?(key) } unless @except.empty?
    else
      object.keep_if { |key, _| @only.include?(key) }
    end
  end

  def filter_first(object)
    if @only.empty?
      object.first.delete_if { |key, _| @except.include?(key) } unless @except.empty?
    else
      object.first.keep_if { |key, _| @only.include?(key) }
    end
  end

  def force_encoding?
    ActiveReport::Settings.config.force_encoding
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

  def metamorph(datum)
    case datum.class.name
    when 'Array'
      if datum.first.is_a?(Array)
        datum.map { |arr| arr.map { |val| metaform(val) } }
      elsif datum.first.is_a?(Hash)
        datum.map { |hsh| hsh.each { |key, val| hsh.store(key, metaform(val)) } }
      else
        datum.map { |val| metaform(val) }
      end
    when 'Hash'
      datum.each { |key, val| datum.store(key, metaform(val)) }
    else
      metaform(datum)
    end
  end

  def metatransform(datum)
    return(nil) if datum.empty?
    evaluate? ? metamorph(datum) : datum
  end

  def munge(object)
    object.is_a?(Array) ? object : merge(object)
  end

  def munge_first(object)
    object.first.is_a?(Array) ? object : merge(object)
  end

end
