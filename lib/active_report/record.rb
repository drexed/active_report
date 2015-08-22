require "json"
class ActiveReport::Record

  attr_accessor :datum, :model, :only, :except, :headers, :options

  def initialize(datum, model: nil, only: nil, except: nil, headers: nil, options: {})
    @datum   = datum
    @model   = model
    @only    = only
    @except  = except
    @headers = headers
    @options = options
  end

  def self.export(datum, only: nil, except: nil, headers: nil, options: {})
    new(datum, only: only, except: except, headers: headers, options: options).export
  end

  def self.import(datum, only: nil, except: nil, headers: nil, options: {}, model: nil)
    new(datum, only: only, except: except, headers: headers, options: options, model: model).import
  end

  def export
    @datum  = @datum.is_a?(ActiveRecord::Relation) ? JSON.parse(@datum.to_json).flatten : [].push(@datum.attributes).compact
    @only   = (@only.is_a?(Array)   ? @only   : [].push(@only).compact).map(&:to_s)
    @except = (@except.is_a?(Array) ? @except : [].push(@except).compact).map(&:to_s)

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
    if @model.nil? || (@model.superclass != ActiveRecord::Base)
      raise ArgumentError,
        "Model must be an ActiveRecord::Base object."
    end

    @only   = [].push(@only).compact   unless @only.is_a?(Array)
    @except = [].push(@except).compact unless @except.is_a?(Array)

    @datum = ActiveReport::Hash.import(@datum, headers: @headers, options: @options)
    @datum.each do |data|
      data.transform_keys! { |k| k.to_s.downcase.gsub(" ", "_").to_sym }
      data.except!(:id)

      data.only!(@only)     unless @only.empty?
      data.except!(@except) unless @except.empty?

      @model.create(data)
    end
  end

end