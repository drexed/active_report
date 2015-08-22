class ActiveReport::Hash

  attr_accessor :datum, :only, :except, :headers, :options

  def initialize(datum, only: nil, except: nil, headers: nil, options: {})
    @datum   = datum
    @only    = only
    @except  = except
    @headers = headers
    @options = options
  end

  def self.export(datum, only: nil, except: nil, headers: nil, options: {})
    new(datum, only: only, except: except, headers: headers, options: options).export
  end

  def self.import(datum, only: nil, except: nil, headers: nil, options: {})
    new(datum, only: only, except: except, headers: headers, options: options).import
  end

  def export
    @datum  = [].push(@datum).compact  unless @datum.is_a?(Array)
    @only   = [].push(@only).compact   unless @only.is_a?(Array)
    @except = [].push(@except).compact unless @except.is_a?(Array)

    CSV.generate(@options) do |csv|
      header = @datum.first.only(@only)     unless @only.empty?
      header = @datum.first.except(@except) unless @except.empty?
      csv << (@headers || (header || @datum.first).keys.map { |k| k.to_s.gsub("_", " ").capitalize })

      @datum.each do |data|
        cell = data.only(@only)     unless @only.empty?
        cell = data.except(@except) unless @except.empty?
        csv << (cell || data).values
      end
    end
  end

  def import
    @only   = [].push(@only).compact   unless @only.is_a?(Array)
    @except = [].push(@except).compact unless @except.is_a?(Array)

    processed_datum = []
    CSV.foreach(@datum, @options).each_with_index do |data, line|
      if @headers.nil? && line.zero?
        @headers = data
      else
        processed_data = {}
        @headers.each_with_index do |v, i|
          processed_data.store(v.to_s, data.fetch(i, nil) )
        end

        processed_data.only!(@only)     unless @only.empty?
        processed_data.except!(@except) unless @except.empty?

        processed_datum.push(processed_data)
      end
    end
    return(processed_datum)
  end

end