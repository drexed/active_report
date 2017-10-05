# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Hash do
  let(:only_except_1) do
    ['Name']
  end
  let(:only_except_2) do
    ['Id', 'Name']
  end
  let(:header_type_1) do
    ['Id', 'Name', 'Speed', 'Hp', 'Crash safety rated', 'Created at']
  end
  let(:header_type_2) do
    ['No.', 'Model', 'Speed', 'Horse Power', 'Crash Safety Rated', 'Driven On']
  end
  let(:hash_type_1) do
    {
      'Id' => '1', 'Name' => 'Porche', 'Speed' => '225', 'Hp' => '430',
      'Crash safety rated' => 'true', 'Created at' => '2014-08-22T20:59:34.000Z'
    }
  end
  let(:hash_type_2) do
    {
      'Id' => 1, 'Name' => 'Porche', 'Speed' => 225, 'Hp' => 430,
      'Crash safety rated' => true, 'Created at' => '2014-08-22T20:59:34.000Z'
    }
  end
  let(:array_type_1) do
    [
      {
        'Id' => '1', 'Name' => 'Ferrari', 'Speed' => '235', 'Hp' => '630',
        'Crash safety rated' => 'true', 'Created at' => '2014-08-23T20:59:34.000Z'
      },
      {
        'Id' => '2', 'Name' => 'Lamborghini', 'Speed' => '245', 'Hp' => '720',
        'Crash safety rated' => 'true', 'Created at' => '2014-08-24T20:59:34.000Z'
      },
      {
        'Id' => '3', 'Name' => 'Bugatti', 'Speed' => '256', 'Hp' => '1001',
        'Crash safety rated' => 'false', 'Created at' => '2014-08-25T20:59:34.000Z'
      }
    ]
  end
  let(:array_type_2) do
    [
      {
        'Id' => 1, 'Name' => 'Ferrari', 'Speed' => 235, 'Hp' => 630,
        'Crash safety rated' => true, 'Created at' => '2014-08-23T20:59:34.000Z'
      },
      {
        'Id' => 2, 'Name' => 'Lamborghini', 'Speed' => 245, 'Hp' => 720,
        'Crash safety rated' => true, 'Created at' => '2014-08-24T20:59:34.000Z'
      },
      {
        'Id' => 3, 'Name' => 'Bugatti', 'Speed' => 256, 'Hp' => 1001,
        'Crash safety rated' => false, 'Created at' => '2014-08-25T20:59:34.000Z'
      }
    ]
  end

  context 'export to csv all data for an' do
    it 'array of hashes' do
      sarr = File.read(multi_all_path)
      ccsv = ActiveReport::Hash.export(array_type_1)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read(solo_all_path)
      ccsv = ActiveReport::Hash.export(hash_type_1)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv only values for an' do
    it 'array of hashes' do
      sarr = File.read(multi_only_path)
      ccsv = ActiveReport::Hash.export(array_type_1,
                                       only: only_except_2)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read(solo_only_path)
      ccsv = ActiveReport::Hash.export(hash_type_1,
                                       only: only_except_1)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv except values for an' do
    it 'array of hashes' do
      sarr = File.read(multi_except_path)
      ccsv = ActiveReport::Hash.export(array_type_1,
                                       except: only_except_2)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read(solo_except_path)
      ccsv = ActiveReport::Hash.export(hash_type_1,
                                       except: only_except_1)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with headers for an' do
    it 'array of hashes' do
      sarr = File.read(multi_headers_path)
      ccsv = ActiveReport::Hash.export(array_type_1,
                                       headers: header_type_2)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read(solo_headers_path)
      ccsv = ActiveReport::Hash.export(hash_type_1,
                                       headers: header_type_2)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with options for an' do
    it 'array of hashes' do
      sarr = File.read(multi_options_path)
      ccsv = ActiveReport::Hash.export(array_type_1,
                                       options: options)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read(solo_options_path)
      ccsv = ActiveReport::Hash.export(hash_type_1,
                                       options: options)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'import csv without headers returns' do
    it 'an array of hashes' do
      carr = ActiveReport::Hash.import(multi_all_path)

      expect(carr).to eq(array_type_1)
    end

    it 'an evaluated array of hashes' do
      carr = ActiveReport::Hash.evaluate.import(multi_all_path)

      expect(carr).to eq(array_type_2)
    end

    it 'a hash' do
      carr = ActiveReport::Hash.import(solo_all_path)

      expect(carr).to eq(hash_type_1)
    end

    it 'an evaluated hash' do
      carr = ActiveReport::Hash.evaluate.import(solo_all_path)

      expect(carr).to eq(hash_type_2)
    end
  end

  context 'import csv with headers returns' do
    it 'an array of hashes' do
      carr = ActiveReport::Hash.import(multi_headerless_path,
                                       headers: header_type_1)

      expect(carr).to eq(array_type_1)
    end

    it 'an evaluated array of hashes' do
      carr = ActiveReport::Hash.evaluate.import(multi_headerless_path,
                                                headers: header_type_1)

      expect(carr).to eq(array_type_2)
    end

    it 'a hash' do
      carr = ActiveReport::Hash.import(solo_headerless_path,
                                       headers: header_type_1)

      expect(carr).to eq(hash_type_1)
    end

    it 'an evaluated hash' do
      carr = ActiveReport::Hash.evaluate.import(solo_headerless_path,
                                                headers: header_type_1)

      expect(carr).to eq(hash_type_2)
    end
  end

  context 'import csv only values returns' do
    it 'an array of arrays' do
      sarr = array_type_1.dup.map { |v| v.dup.keep_if { |k, v| only_except_2.include?(k) } }
      carr = ActiveReport::Hash.import(multi_headerless_path,
                                       headers: header_type_1,
                                       only: only_except_2)

      expect(carr).to eq(sarr)
    end

    it 'an evaluated array of arrays' do
      sarr = array_type_2.dup.map { |v| v.dup.keep_if { |k, v| only_except_2.include?(k) } }
      carr = ActiveReport::Hash.evaluate.import(multi_headerless_path,
                                                headers: header_type_1,
                                                only: only_except_2)

      expect(carr).to eq(sarr)
    end

    it 'a hash' do
      sarr = hash_type_1.dup.keep_if { |k, v| only_except_1.include?(k) }
      carr = ActiveReport::Hash.import(solo_headerless_path,
                                       headers: header_type_1,
                                       only: only_except_1)

      expect(carr).to eq(sarr)
    end

    it 'an evaluated hash' do
      sarr = hash_type_2.dup.keep_if { |k, v| only_except_1.include?(k) }
      carr = ActiveReport::Hash.evaluate.import(solo_headerless_path,
                                                headers: header_type_1,
                                                only: only_except_1)

      expect(carr).to eq(sarr)
    end
  end

  context 'import csv except values returns' do
    it 'an array of arrays' do
      sarr = array_type_1.dup.map { |v| v.dup.delete_if { |k, v| only_except_2.include?(k) } }
      carr = ActiveReport::Hash.import(multi_headerless_path,
                                       headers: header_type_1,
                                       except: only_except_2)

      expect(carr).to eq(sarr)
    end

    it 'an evaluated array of arrays' do
      sarr = array_type_2.dup.map { |v| v.dup.delete_if { |k, v| only_except_2.include?(k) } }
      carr = ActiveReport::Hash.evaluate.import(multi_headerless_path,
                                                headers: header_type_1,
                                                except: only_except_2)

      expect(carr).to eq(sarr)
    end

    it 'a hash' do
      sarr = hash_type_1.dup.delete_if { |k, v| only_except_1.include?(k) }
      carr = ActiveReport::Hash.import(solo_headerless_path,
                                       headers: header_type_1,
                                       except: only_except_1)

      expect(carr).to eq(sarr)
    end

    it 'an evaluated hash' do
      sarr = hash_type_2.dup.delete_if { |k, v| only_except_1.include?(k) }
      carr = ActiveReport::Hash.evaluate.import(solo_headerless_path,
                                                headers: header_type_1,
                                                except: only_except_1)

      expect(carr).to eq(sarr)
    end
  end

  context 'import csv with options returns' do
    it 'an array of hashes' do
      carr = ActiveReport::Hash.import(multi_headerless_options_path,
                                       headers: header_type_1,
                                       options: options)

      expect(carr).to eq(array_type_1)
    end

    it 'an evaluated array of hashes' do
      carr = ActiveReport::Hash.evaluate.import(multi_headerless_options_path,
                                                headers: header_type_1,
                                                options: options)

      expect(carr).to eq(array_type_2)
    end

    it 'a hash' do
      carr = ActiveReport::Hash.import(solo_headerless_options_path,
                                       headers: header_type_1,
                                       options: options)

      expect(carr).to eq(hash_type_1)
    end

    it 'an evaluated hash' do
      carr = ActiveReport::Hash.evaluate.import(solo_headerless_options_path,
                                                headers: header_type_1,
                                                options: options)

      expect(carr).to eq(hash_type_2)
    end
  end

end
