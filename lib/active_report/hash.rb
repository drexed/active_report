class ActiveReport::Hash < ActiveReport::Base

  attr_accessor :datum, :only, :except, :headers, :options

  def initialize(datum, only: nil, except: nil, headers: nil, options: {})
    @datum = datum
    @except = except
    @headers = headers
    @only = only
    @options = duplicate_options.merge!(options)
  end

  def self.export(datum, only: nil, except: nil, headers: nil, options: {})
    new(datum, only: only, except: except, headers: headers, options: options).export
  end

  def self.import(datum, only: nil, except: nil, headers: nil, options: {})
    new(datum, only: only, except: except, headers: headers, options: options).import
  end

  def export
    @datum = munge(@datum)
    @only = munge(@only)
    @except = munge(@except)

    CSV.generate(@options) do |csv|
      csv << (@headers || (filter_first(@datum) || @datum.first).keys.map { |hdr| humanize(hdr) })
      @datum.lazy.each { |data| csv << (filter(data) || data).values }
    end
  end

  def import
    @only = munge(@only)
    @except = munge(@except)

    datum = []
    CSV.foreach(@datum, @options).with_index do |data, line|
      data = encode_to_utf8(data) if force_encoding?

      if @headers.nil? && line.zero?
        @headers = data
      else
        subdata = {}
        @headers.lazy.each_with_index do |header, idx|
          subdata.store(header.to_s, data[idx])
        end
        filter(subdata)
        datum.push(subdata)
      end
    end

    datum = datum.first if datum.size == 1
    datum = metatransform(datum)
    datum
  end

end