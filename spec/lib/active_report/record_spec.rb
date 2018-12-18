# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Record do
  let(:hash_type_1) do
    { name: 'Porche', speed: '225', hp: '430', crash_safety_rated: 'true', created_at: '2014-08-22T20:59:34.000Z' }
  end
  let(:hash_type_2) do
    [
      { name: 'Ferrari', speed: '235', hp: '630', crash_safety_rated: 'true', created_at: '2014-08-23T20:59:34.000Z' },
      { name: 'Lamborghini', speed: '245', hp: '720', crash_safety_rated: 'true', created_at: '2014-08-24T20:59:34.000Z' },
      { name: 'Bugatti', speed: '256', hp: '1001', crash_safety_rated: 'false', created_at: '2014-08-25T20:59:34.000Z' }
    ]
  end
  let(:hash_type_3) do
    { id: 1, name: 'Porche', speed: '225', hp: '430', crash_safety_rated: 'true', created_at: '2014-08-22T20:59:34.000Z' }
  end
  let(:hash_type_4) do
    [
      { id: 1, name: 'Ferrari', speed: '235', hp: '630',  crash_safety_rated: 'true',  created_at: '2014-08-23T20:59:34.000Z' },
      { id: 2, name: 'Lamborghini', speed: '245', hp: '720',  crash_safety_rated: 'true',  created_at: '2014-08-24T20:59:34.000Z' },
      { id: 3, name: 'Bugatti', speed: '256', hp: '1001', crash_safety_rated: 'false', created_at: '2014-08-25T20:59:34.000Z' }
    ]
  end

  context 'export stream' do
    it 'returns true for query class' do
      Car.create!(hash_type_1)

      ccsv = ActiveReport::Record.export(Car.all, stream: true)

      expect(ccsv.is_a?(Enumerator)).to eq(true)
    end
  end

  context 'export to csv all data for an' do
    it 'array of records from a Class dump' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_all_path)
      ccsv = ActiveReport::Record.export(Car)

      expect(ccsv).to eq(sarr)
    end

    it 'array of records from a ActiveRelation dump' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_dump_path)
      ccsv = ActiveReport::Record.export(Car.where(speed: 235..245))

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv all data for an' do
    it 'array of records' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_all_path)
      ccsv = ActiveReport::Record.export(Car.all)

      expect(ccsv).to eq(sarr)
    end

    it 'record' do
      Car.create!(hash_type_1)

      sarr = File.read(solo_all_path)
      ccsv = ActiveReport::Record.export(Car.first)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv only values for an' do
    it 'array of records' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_only_path)
      ccsv = ActiveReport::Record.export(Car.all,
                                         only: [:id, :name])

      expect(ccsv).to eq(sarr)
    end

    it 'record' do
      Car.create!(hash_type_1)

      sarr = File.read(solo_only_path)
      ccsv = ActiveReport::Record.export(Car.first,
                                         only: :name)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv except values for an' do
    it 'array of records' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_except_path)
      ccsv = ActiveReport::Record.export(Car.all,
                                         except: [:id, :name])

      expect(ccsv).to eq(sarr)
    end

    it 'record' do
      Car.create!(hash_type_1)

      sarr = File.read(solo_except_path)
      ccsv = ActiveReport::Record.export(Car.first,
                                         except: :name)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with headers for an' do
    it 'array of records' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_headers_path)
      ccsv = ActiveReport::Record.export(Car.all,
                                         headers: header_type_2)

      expect(ccsv).to eq(sarr)
    end

    it 'record' do
      Car.create!(hash_type_1)

      sarr = File.read(solo_headers_path)
      ccsv = ActiveReport::Record.export(Car.first,
                                         headers: header_type_2)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with options for an' do
    it 'array of records' do
      hash_type_2.each { |v| Car.create!(v) }

      sarr = File.read(multi_options_path)
      ccsv = ActiveReport::Record.export(Car.all,
                                         options: options)

      expect(ccsv).to eq(sarr)
    end

    it 'record' do
      Car.create!(hash_type_1)

      sarr = File.read(solo_options_path)
      ccsv = ActiveReport::Record.export(Car.first,
                                         options: options)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'import csv without headers to create' do
    it '3 cars' do
      ActiveReport::Record.import(multi_all_path,
                                  model: Car)

      expect(Car.count).to eq(3)
    end

    it '1 car' do
      ActiveReport::Record.import(solo_all_path,
                                  model: Car)

      expect(Car.count).to eq(1)
    end
  end

  context 'import csv with headers to create' do
    it '3 cars' do
      ActiveReport::Record.import(multi_headerless_path,
                                  model: Car,
                                  headers: header_type_1)

      expect(Car.count).to eq(3)
    end

    it '1 car' do
      ActiveReport::Record.import(solo_headerless_path,
                                  model: Car,
                                  headers: header_type_1)

      expect(Car.count).to eq(1)
    end
  end

  context 'import csv only values to create' do
    it '3 cars' do
      ActiveReport::Record.import(multi_headerless_path,
                                  model: Car,
                                  headers: header_type_1,
                                  only: :name)

      expect(Car.where.not(name: nil).count).to eq(3)
    end

    it '1 car' do
      ActiveReport::Record.import(solo_headerless_path,
                                  model: Car,
                                  headers: header_type_1,
                                  only: :name)

      expect(Car.where.not(name: nil).count).to eq(1)
    end
  end

  context 'import csv except values to create' do
    it '3 cars' do
      ActiveReport::Record.import(multi_headerless_path,
                                  model: Car,
                                  headers: header_type_1,
                                  except: :name)

      expect(Car.where(name: nil).count).to eq(3)
    end

    it '1 car' do
      ActiveReport::Record.import(solo_headerless_path,
                                  model: Car,
                                  headers: header_type_1,
                                  except: :name)

      expect(Car.where(name: nil).count).to eq(1)
    end
  end

  context 'import csv with options to create' do
    it '3 cars' do
      ActiveReport::Record.import(multi_headerless_options_path,
                                  model: Car,
                                  headers: header_type_1,
                                  options: options)

      expect(Car.count).to eq(3)
    end

    it '1 car' do
      ActiveReport::Record.import(solo_headerless_options_path,
                                  model: Car,
                                  headers: header_type_1,
                                  options: options)

      expect(Car.count).to eq(1)
    end
  end

end
