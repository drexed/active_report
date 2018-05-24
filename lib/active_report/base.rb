# frozen_string_literal: true

class ActiveReport::Base

  @@evaluate = false

  def initialize(data, opts = {})
    @data = data
    @opts = opts

    %i[except only].each { |key| @opts[key] = munge(@opts[key]) }
    { batch_size: 1_000, options: csv_options }.each { |key, val| @opts[key] ||= val }
  end

  def csv_options
    ActiveReport.configuration.csv_options
  end

  def csv_force_encoding?
    ActiveReport.configuration.csv_force_encoding
  end

  def import_adapter
    ActiveReport.configuration.import_adapter
  end

  def import_options
    ActiveReport.configuration.import_options
  end

  def self.evaluate(value = true)
    @@evaluate = value
    self
  end

  def self.export(data, opts = {})
    klass = new(data, opts)
    klass.export
  end

  def self.import(data, opts = {})
    klass = new(data, opts)
    klass.import
  end

  private

  def active_record_table_object?(object)
    return if object.nil?
    !object.respond_to?(:table_name)
  end

  def active_record_table_class?(object)
    return if object.nil? || object.is_a?(ActiveRecord::Relation)
    object.respond_to?(:table_name) || object.is_a?(Ransack::Search)
  end

  def encode_to_utf8(line)
    line.map do |chr|
      next if chr.nil?

      chr = chr.tr('"', '')
      chr.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end
  end

  def evaluate?
    value = @@evaluate
    @@evaluate = false
    value
  end

  def filter(object)
    if @opts[:only].empty?
      return object if @opts[:except].empty?

      object.delete_if { |key, _| @opts[:except].include?(key) }
    else
      object.keep_if { |key, _| @opts[:only].include?(key) }
    end
  end

  def humanize(object)
    object.to_s.tr('_', ' ').capitalize
  end

  def humanize_values(data)
    data.map { |col| humanize(col) }
  end

  def merge(object)
    [object].compact
  end

  # rubocop:disable Security/Eval, Lint/RescueException
  def metaform(value)
    eval(value.to_s)
  rescue Exception
    value
  end
  # rubocop:enable Security/Eval, Lint/RescueException

  def metaform_array(data)
    data.map { |val| metaform(val) }
  end

  def metaform_hash(data)
    data.each { |key, val| data[key] = metaform(val) }
  end

  def metamorph_array(data)
    case data.first.class.name
    when 'Array' then data.map { |arr| metaform_array(arr) }
    when 'Hash' then data.map { |hsh| metaform_hash(hsh) }
    else metaform_array(data)
    end
  end

  def metamorph(data)
    case data.class.name
    when 'Array' then metamorph_array(data)
    when 'Hash' then metaform_hash(data)
    else metaform(data)
    end
  end

  def metatransform(data)
    return if data.empty?
    evaluate? ? metamorph(data) : data
  end

  def munge(data)
    data.is_a?(Array) ? data : merge(data)
  end

  def munge_first(data)
    data.first.is_a?(Array) ? data : merge(data)
  end

  def filter_values(data)
    filter(data).values
  end

  def filter_humanize_keys(data)
    filter(data.first).collect { |key, _| humanize(key) }
  end

end
