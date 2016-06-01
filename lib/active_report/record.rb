require "json"
class ActiveReport::Record < ActiveReport::Base

  attr_accessor :datum, :model, :only, :except, :headers, :options

  def initialize(datum, model: nil, only: nil, except: nil, headers: nil, options: {})
    @datum, @except, @headers, @model, @only = datum, except, headers, model, only
    @options = duplicate_options.merge!(options)
  end

  def self.export(datum, only: nil, except: nil, headers: nil, options: {})
    new(datum, only: only, except: except, headers: headers, options: options).export
  end

  def self.import(datum, only: nil, except: nil, headers: nil, options: {}, model: nil)
    new(datum, only: only, except: except, headers: headers, options: options, model: model).import
  end

  def export
    @datum = @datum.is_a?(ActiveRecord::Relation) ? JSON.parse(@datum.to_json).flatten : merge(@datum.attributes)
    @only, @except = munge(@only).map(&:to_s), munge(@except).map(&:to_s)

    CSV.generate(@options) do |csv|
      csv << (@headers || (filter_first(@datum) || @datum.first).keys.map { |header| humanize(header) })
      @datum.lazy.each { |data| csv << (filter(data) || data).values }
    end
  end

  def import
    if @model.nil? || (@model.superclass != ActiveRecord::Base)
      raise ArgumentError, "Model must be an ActiveRecord::Base object."
    end

    @datum = ActiveReport::Hash.import(@datum, headers: @headers, options: @options)
    @only, @except = munge(@only), munge(@except)

    @datum.lazy.each do |data|
      data.transform_keys! { |key| key.to_s.downcase.gsub(" ", "_").to_sym }
      filter(data)
      data.delete(:id)
      @model.create(data)
    end
  end

end
