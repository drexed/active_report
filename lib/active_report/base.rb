class ActiveReport::Base

  @@evaluate = false

  def self.evaluate(value=true)
    @@evaluate = value
    self
  end

  private

  def duplicate_options
    ActiveReport.configuration.options.dup
  end

  def encode_to_utf8(line)
    line.map do |chr|
      next if chr.nil?
      chr.gsub!(/"/, '')
      chr.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end
  end

  def evaluate?
    value = @@evaluate
    @@evaluate = false
    value
  end

  def filter(object)
    if @only.empty?
      object.delete_if { |key, value| @except.include?(key) } unless @except.empty?
    else
      object.keep_if { |key, value| @only.include?(key) }
    end
  end

  def filter_first(object)
    if @only.empty?
      object.first.delete_if { |key, value| @except.include?(key) } unless @except.empty?
    else
      object.first.keep_if { |key, value| @only.include?(key) }
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

  def metaform(value)
    value.nil? ? value : eval(value)
  rescue Exception
    value
  end

  def metamorph(datum)
    case datum.class.name
    when 'Array'
      if datum.first.is_a?(Array)
        datum.map { |array| array.map { |value| metaform(value) } }
      elsif datum.first.is_a?(Hash)
        datum.map { |hash| hash.each { |key, value| hash.store(key, metaform(value)) } }
      else
        datum.map { |value| metaform(value) }
      end
    when 'Hash'
      datum.each { |key, value| datum.store(key, metaform(value)) }
    else
      metaform(datum)
    end
  end

  def metatransform(datum)
    datum.empty? ? nil : (evaluate? ? metamorph(datum) : datum)
  end

  def munge(object)
    object.is_a?(Array) ? object : merge(object)
  end

  def munge_first(object)
    object.first.is_a?(Array) ? object : merge(object)
  end

end
