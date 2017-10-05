# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Array do

  let(:sh1) { ['Id', 'Name', 'Speed', 'Hp', 'Crash safety rated', 'Created at'] }
  let(:sh2) { ['No.', 'Model', 'Speed', 'Horse Power', 'Crash Safety Rated', 'Driven On'] }
  let(:sc1) { ['1', 'Porche', '225', '430', 'true', '2014-08-22T20:59:34.000Z'] }
  let(:sc2) { [1, 'Porche', 225, 430, true, '2014-08-22T20:59:34.000Z'] }
  let(:sc3) {
    [
      ['1', 'Ferrari', '235', '630', 'true', '2014-08-23T20:59:34.000Z'],
      ['2', 'Lamborghini', '245', '720', 'true', '2014-08-24T20:59:34.000Z'],
      ['3', 'Bugatti', '256', '1001', 'false', '2014-08-25T20:59:34.000Z']
    ]
  }
  let(:sc4) {
    [
      [1, 'Ferrari', 235, 630, true, '2014-08-23T20:59:34.000Z'],
      [2, 'Lamborghini', 245, 720, true, '2014-08-24T20:59:34.000Z'],
      [3, 'Bugatti', 256, 1001, false, '2014-08-25T20:59:34.000Z']
    ]
  }

  context 'export to csv without headers for an' do
    it 'array of arrays' do
      sarr = File.read('spec/support/csv/multi_headerless.csv')
      ccsv = ActiveReport::Array.export(sc3)

      expect(ccsv).to eq(sarr)
    end

    it 'array' do
      sarr = File.read('spec/support/csv/solo_headerless.csv')
      ccsv = ActiveReport::Array.export(sc1)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with headers for an' do
    it 'array of arrays' do
      sarr = File.read('spec/support/csv/multi_headers.csv')
      ccsv = ActiveReport::Array.export(sc3, headers: sh2)

      expect(ccsv).to eq(sarr)
    end

    it 'array' do
      sarr = File.read('spec/support/csv/solo_headers.csv')
      ccsv = ActiveReport::Array.export(sc1, headers: sh2)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with options for an' do
    it 'array of arrays' do
      sarr = File.read('spec/support/csv/multi_options.csv')
      ccsv = ActiveReport::Array.export(sc3, headers: sh1, options: { col_sep: ';' })

      expect(ccsv).to eq(sarr)
    end

    it 'array' do
      sarr = File.read('spec/support/csv/solo_options.csv')
      ccsv = ActiveReport::Array.export(sc1, headers: sh1, options: { col_sep: ';' })

      expect(ccsv).to eq(sarr)
    end
  end

  context 'import csv without headers returns an' do
    it 'array of arrays' do
      carr = ActiveReport::Array.import('spec/support/csv/multi_headerless.csv')

      expect(carr).to eq(sc3)
    end

    it 'evaluated array of arrays' do
      carr = ActiveReport::Array.evaluate.import('spec/support/csv/multi_headerless.csv')

      expect(carr).to eq(sc4)
    end

    it 'array' do
      carr = ActiveReport::Array.import('spec/support/csv/solo_headerless.csv')

      expect(carr).to eq(sc1)
    end

    it 'evaluated array' do
      carr = ActiveReport::Array.evaluate.import('spec/support/csv/solo_headerless.csv')

      expect(carr).to eq(sc2)
    end
  end

  context 'import csv with headers returns an' do
    it 'array of arrays' do
      carr = ActiveReport::Array.import('spec/support/csv/multi_headerless.csv', headers: sh1)

      expect(carr).to eq(sc3.dup.unshift(sh1))
    end

    it 'evaluated array of arrays' do
      carr = ActiveReport::Array.evaluate.import('spec/support/csv/multi_headerless.csv', headers: sh1)

      expect(carr).to eq(sc4.dup.unshift(sh1))
    end

    it 'array' do
      carr = ActiveReport::Array.import('spec/support/csv/solo_headerless.csv', headers: sh1)

      expect(carr).to eq([].push(sh1).push(sc1))
    end

    it 'evaluated array' do
      carr = ActiveReport::Array.evaluate.import('spec/support/csv/solo_headerless.csv', headers: sh1)

      expect(carr).to eq([].push(sh1).push(sc2))
    end
  end

  context 'import csv with options returns an' do
    it 'array of arrays' do
      carr = ActiveReport::Array.import('spec/support/csv/multi_options.csv', options: { col_sep: ';' })

      expect(carr).to eq([].push(sh1).concat(sc3))
    end

    it 'evaluated array of arrays' do
      carr = ActiveReport::Array.evaluate.import('spec/support/csv/multi_options.csv', options: { col_sep: ';' })

      expect(carr).to eq([].push(sh1).concat(sc4))
    end

    it 'array' do
      carr = ActiveReport::Array.import('spec/support/csv/solo_options.csv', options: { col_sep: ';' })

      expect(carr).to eq([].push(sh1).push(sc1))
    end

    it 'evaluated array' do
      carr = ActiveReport::Array.evaluate.import('spec/support/csv/solo_options.csv', options: { col_sep: ';' })

      expect(carr).to eq([].push(sh1).push(sc2))
    end
  end

end
