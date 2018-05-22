# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Array do
  let(:header_type_1) do
    ['Id', 'Name', 'Speed', 'Hp', 'Crash safety rated', 'Created at']
  end
  let(:header_type_2) do
    ['No.', 'Model', 'Speed', 'Horse Power', 'Crash Safety Rated', 'Driven On']
  end
  let(:array_type_1) do
    ['1', 'Porche', '225', '430', 'true', '2014-08-22T20:59:34.000Z']
  end
  let(:array_type_2) do
    [1, 'Porche', 225, 430, true, '2014-08-22T20:59:34.000Z']
  end
  let(:array_type_3) do
    [
      ['1', 'Ferrari', '235', '630', 'true', '2014-08-23T20:59:34.000Z'],
      ['2', 'Lamborghini', '245', '720', 'true', '2014-08-24T20:59:34.000Z'],
      ['3', 'Bugatti', '256', '1001', 'false', '2014-08-25T20:59:34.000Z']
    ]
  end
  let(:array_type_4) do
    [
      [1, 'Ferrari', 235, 630, true, '2014-08-23T20:59:34.000Z'],
      [2, 'Lamborghini', 245, 720, true, '2014-08-24T20:59:34.000Z'],
      [3, 'Bugatti', 256, 1001, false, '2014-08-25T20:59:34.000Z']
    ]
  end

  context 'export stream' do
    it 'returns true' do
      ccsv = ActiveReport::Array.export(array_type_3, stream: true)

      expect(ccsv.is_a?(Enumerator)).to eq(true)
    end
  end

  context 'export to csv without headers for an' do
    it 'array of arrays' do
      sarr = File.read(multi_headerless_path)
      ccsv = ActiveReport::Array.export(array_type_3)

      expect(ccsv).to eq(sarr)
    end

    it 'array' do
      sarr = File.read(solo_headerless_path)
      ccsv = ActiveReport::Array.export(array_type_1)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with headers for an' do
    it 'array of arrays' do
      sarr = File.read(multi_headers_path)
      ccsv = ActiveReport::Array.export(array_type_3,
                                        headers: header_type_2)

      expect(ccsv).to eq(sarr)
    end

    it 'array' do
      sarr = File.read(solo_headers_path)
      ccsv = ActiveReport::Array.export(array_type_1,
                                        headers: header_type_2)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with options for an' do
    it 'array of arrays' do
      sarr = File.read(multi_options_path)
      ccsv = ActiveReport::Array.export(array_type_3,
                                        headers: header_type_1,
                                        options: options)

      expect(ccsv).to eq(sarr)
    end

    it 'array' do
      sarr = File.read(solo_options_path)
      ccsv = ActiveReport::Array.export(array_type_1,
                                        headers: header_type_1,
                                        options: options)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'import csv without headers returns an' do
    it 'array of arrays' do
      carr = ActiveReport::Array.import(multi_headerless_path)

      expect(carr).to eq(array_type_3)
    end

    it 'evaluated array of arrays' do
      carr = ActiveReport::Array.evaluate.import(multi_headerless_path)

      expect(carr).to eq(array_type_4)
    end

    it 'array' do
      carr = ActiveReport::Array.import(solo_headerless_path)

      expect(carr).to eq(array_type_1)
    end

    it 'evaluated array' do
      carr = ActiveReport::Array.evaluate.import(solo_headerless_path)

      expect(carr).to eq(array_type_2)
    end
  end

  context 'import csv with headers returns an' do
    it 'array of arrays' do
      carr = ActiveReport::Array.import(multi_headerless_path,
                                        headers: header_type_1)

      expect(carr).to eq(array_type_3.dup.unshift(header_type_1))
    end

    it 'evaluated array of arrays' do
      carr = ActiveReport::Array.evaluate.import(multi_headerless_path,
                                                 headers: header_type_1)

      expect(carr).to eq(array_type_4.dup.unshift(header_type_1))
    end

    it 'array' do
      carr = ActiveReport::Array.import(solo_headerless_path,
                                        headers: header_type_1)

      expect(carr).to eq([].push(header_type_1).push(array_type_1))
    end

    it 'evaluated array' do
      carr = ActiveReport::Array.evaluate.import(solo_headerless_path,
                                                 headers: header_type_1)

      expect(carr).to eq([].push(header_type_1).push(array_type_2))
    end
  end

  context 'import csv with options returns an' do
    it 'array of arrays' do
      carr = ActiveReport::Array.import(multi_options_path,
                                        options: options)

      expect(carr).to eq([].push(header_type_1).concat(array_type_3))
    end

    it 'evaluated array of arrays' do
      carr = ActiveReport::Array.evaluate.import(multi_options_path,
                                                 options: options)

      expect(carr).to eq([].push(header_type_1).concat(array_type_4))
    end

    it 'array' do
      carr = ActiveReport::Array.import(solo_options_path,
                                        options: options)

      expect(carr).to eq([].push(header_type_1).push(array_type_1))
    end

    it 'evaluated array' do
      carr = ActiveReport::Array.evaluate.import(solo_options_path,
                                                 options: options)

      expect(carr).to eq([].push(header_type_1).push(array_type_2))
    end
  end

end
