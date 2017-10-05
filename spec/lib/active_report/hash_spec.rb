# frozen_string_literal: true

require 'spec_helper'

describe ActiveReport::Hash do

  let(:sh1) { ['Id', 'Name', 'Speed', 'Hp', 'Crash safety rated', 'Created at'] }
  let(:sh2) { ['No.', 'Model', 'Speed', 'Horse Power', 'Crash Safety Rated', 'Driven On'] }
  let(:sc1) {
    {
      'Id' => '1', 'Name' => 'Porche', 'Speed' => '225', 'Hp' => '430',
      'Crash safety rated' => 'true', 'Created at' => '2014-08-22T20:59:34.000Z'
    }
  }
  let(:sc2) {
    {
      'Id' => 1, 'Name' => 'Porche', 'Speed' => 225, 'Hp' => 430,
      'Crash safety rated' => true, 'Created at' => '2014-08-22T20:59:34.000Z'
    }
  }
  let(:sc3) {
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
  }
  let(:sc4) {
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
  }

  context 'export to csv all data for an' do
    it 'array of hashes' do
      sarr = File.read('spec/support/csv/multi_all.csv')
      ccsv = ActiveReport::Hash.export(sc3)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read('spec/support/csv/solo_all.csv')
      ccsv = ActiveReport::Hash.export(sc1)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv only values for an' do
    it 'array of hashes' do
      sarr = File.read('spec/support/csv/multi_only.csv')
      ccsv = ActiveReport::Hash.export(sc3, only: ['Id', 'Name'])

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read('spec/support/csv/solo_only.csv')
      ccsv = ActiveReport::Hash.export(sc1, only: 'Name')

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv except values for an' do
    it 'array of hashes' do
      sarr = File.read('spec/support/csv/multi_except.csv')
      ccsv = ActiveReport::Hash.export(sc3, except: ['Id', 'Name'])

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read('spec/support/csv/solo_except.csv')
      ccsv = ActiveReport::Hash.export(sc1, except: 'Name')

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with headers for an' do
    it 'array of hashes' do
      sarr = File.read('spec/support/csv/multi_headers.csv')
      ccsv = ActiveReport::Hash.export(sc3, headers: sh2)

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read('spec/support/csv/solo_headers.csv')
      ccsv = ActiveReport::Hash.export(sc1, headers: sh2)

      expect(ccsv).to eq(sarr)
    end
  end

  context 'export to csv with options for an' do
    it 'array of hashes' do
      sarr = File.read('spec/support/csv/multi_options.csv')
      ccsv = ActiveReport::Hash.export(sc3, options: { col_sep: ';' })

      expect(ccsv).to eq(sarr)
    end

    it 'hash' do
      sarr = File.read('spec/support/csv/solo_options.csv')
      ccsv = ActiveReport::Hash.export(sc1, options: { col_sep: ';' })

      expect(ccsv).to eq(sarr)
    end
  end

  context 'import csv without headers returns' do
    it 'an array of hashes' do
      carr = ActiveReport::Hash.import('spec/support/csv/multi_all.csv')

      expect(carr).to eq(sc3)
    end

    it 'an evaluated array of hashes' do
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/multi_all.csv')

      expect(carr).to eq(sc4)
    end

    it 'a hash' do
      carr = ActiveReport::Hash.import('spec/support/csv/solo_all.csv')

      expect(carr).to eq(sc1)
    end

    it 'an evaluated hash' do
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/solo_all.csv')

      expect(carr).to eq(sc2)
    end
  end

  context 'import csv with headers returns' do
    it 'an array of hashes' do
      carr = ActiveReport::Hash.import('spec/support/csv/multi_headerless.csv', headers: sh1)

      expect(carr).to eq(sc3)
    end

    it 'an evaluated array of hashes' do
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/multi_headerless.csv', headers: sh1)

      expect(carr).to eq(sc4)
    end

    it 'a hash' do
      carr = ActiveReport::Hash.import('spec/support/csv/solo_headerless.csv', headers: sh1)

      expect(carr).to eq(sc1)
    end

    it 'an evaluated hash' do
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/solo_headerless.csv', headers: sh1)

      expect(carr).to eq(sc2)
    end
  end

  context 'import csv only values returns' do
    it 'an array of arrays' do
      sarr = sc3.dup.map { |v| v.dup.keep_if { |k, v| ['Id', 'Name'].include?(k) } }
      carr = ActiveReport::Hash.import('spec/support/csv/multi_headerless.csv', headers: sh1, only: ['Id', 'Name'])

      expect(carr).to eq(sarr)
    end

    it 'an evaluated array of arrays' do
      sarr = sc4.dup.map { |v| v.dup.keep_if { |k, v| ['Id', 'Name'].include?(k) } }
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/multi_headerless.csv', headers: sh1, only: ['Id', 'Name'])

      expect(carr).to eq(sarr)
    end

    it 'a hash' do
      sarr = sc1.dup.keep_if { |k, v| ['Name'].include?(k) }
      carr = ActiveReport::Hash.import('spec/support/csv/solo_headerless.csv', headers: sh1, only: 'Name')

      expect(carr).to eq(sarr)
    end

    it 'an evaluated hash' do
      sarr = sc2.dup.keep_if { |k, v| ['Name'].include?(k) }
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/solo_headerless.csv', headers: sh1, only: 'Name')

      expect(carr).to eq(sarr)
    end
  end

  context 'import csv except values returns' do
    it 'an array of arrays' do
      sarr = sc3.dup.map { |v| v.dup.delete_if { |k, v| ['Id', 'Name'].include?(k) } }
      carr = ActiveReport::Hash.import('spec/support/csv/multi_headerless.csv', headers: sh1, except: ['Id', 'Name'])

      expect(carr).to eq(sarr)
    end

    it 'an evaluated array of arrays' do
      sarr = sc4.dup.map { |v| v.dup.delete_if { |k, v| ['Id', 'Name'].include?(k) } }
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/multi_headerless.csv', headers: sh1, except: ['Id', 'Name'])

      expect(carr).to eq(sarr)
    end

    it 'a hash' do
      sarr = sc1.dup.delete_if { |k, v| ['Name'].include?(k) }
      carr = ActiveReport::Hash.import('spec/support/csv/solo_headerless.csv', headers: sh1, except: 'Name')

      expect(carr).to eq(sarr)
    end

    it 'an evaluated hash' do
      sarr = sc2.dup.delete_if { |k, v| ['Name'].include?(k) }
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/solo_headerless.csv', headers: sh1, except: 'Name')

      expect(carr).to eq(sarr)
    end
  end

  context 'import csv with options returns' do
    it 'an array of hashes' do
      carr = ActiveReport::Hash.import('spec/support/csv/multi_headerless_options.csv', headers: sh1, options: { col_sep: ';' })

      expect(carr).to eq(sc3)
    end

    it 'an evaluated array of hashes' do
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/multi_headerless_options.csv', headers: sh1, options: { col_sep: ';' })

      expect(carr).to eq(sc4)
    end

    it 'a hash' do
      carr = ActiveReport::Hash.import('spec/support/csv/solo_headerless_options.csv', headers: sh1, options: { col_sep: ';' })

      expect(carr).to eq(sc1)
    end

    it 'an evaluated hash' do
      carr = ActiveReport::Hash.evaluate.import('spec/support/csv/solo_headerless_options.csv', headers: sh1, options: { col_sep: ';' })

      expect(carr).to eq(sc2)
    end
  end

end
