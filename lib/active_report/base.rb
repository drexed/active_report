class ActiveReport::Base

  private

  def duplicate_options
    ActiveReport.configuration.options.dup
  end

  def encode_to_utf8(line)
    line.map do |l|
      next if l.nil?
      l.gsub!(/"/, "")
      l.encode!("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
    end
  end

  def force_encoding?
    ActiveReport.configuration.force_encoding
  end

  def humanize(object)
    object.to_s.gsub("_", " ").capitalize
  end

  def merge(object)
    [].push(object).compact
  end

  def munge(object)
    object.is_a?(Array) ? object : merge(object)
  end

  def munge_first(object)
    object.first.is_a?(Array) ? object : merge(object)
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

end
