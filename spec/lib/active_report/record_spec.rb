require "spec_helper"

describe ActiveReport::Record do

  let(:sample_header) { ["Name", "Speed", "Hp", "Crash safety rated", "Created at"] }
  let(:sample_header_alt) { ["No.", "Model", "Speed", "Horse Power", "Crash Safety Rated", "Driven On"] }
  let(:sample_content) { { name: "Porche", speed: "225", hp: "430", crash_safety_rated: "true", created_at: "2014-08-22T20:59:34.000Z" } }
  let(:sample_content_alt) {
    [
      { name: "Ferrari", speed: "235", hp: "630", crash_safety_rated: "true", created_at: "2014-08-23T20:59:34.000Z" },
      { name: "Lamborghini", speed: "245", hp: "720", crash_safety_rated: "true", created_at: "2014-08-24T20:59:34.000Z" },
      { name: "Bugatti", speed: "256", hp: "1001", crash_safety_rated: "false", created_at: "2014-08-25T20:59:34.000Z" }
    ]
  }
  let(:sample_header_id) { ["Id", "Name", "Speed", "Hp", "Crash safety rated", "Created at"] }
  let(:sample_header_alt_id) { ["Id", "No.", "Model", "Speed", "Horse Power", "Crash Safety Rated", "Driven On"] }
  let(:sample_content_id) { { id: 1, name: "Porche", speed: "225", hp: "430", crash_safety_rated: "true", created_at: "2014-08-22T20:59:34.000Z" } }
  let(:sample_content_alt_id) {
    [
      { id: 1, name: "Ferrari", speed: "235", hp: "630",  crash_safety_rated: "true",  created_at: "2014-08-23T20:59:34.000Z" },
      { id: 2, name: "Lamborghini", speed: "245", hp: "720",  crash_safety_rated: "true",  created_at: "2014-08-24T20:59:34.000Z" },
      { id: 3, name: "Bugatti", speed: "256", hp: "1001", crash_safety_rated: "false", created_at: "2014-08-25T20:59:34.000Z" }
    ]
  }

  context "export to csv all data for an" do
    it "array of records" do
      sample_content_alt.each { |data| Car.create!(data) }

      sample_csv = File.read("spec/support/csv/multi_all.csv")
      constructed_csv = ActiveReport::Record.export(Car.all)

      expect(constructed_csv).to eq(sample_csv)
    end

    it "record" do
      Car.create!(sample_content)

      sample_csv = File.read("spec/support/csv/solo_all.csv")
      constructed_csv = ActiveReport::Record.export(Car.first)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv only values for an" do
    it "array of records" do
      sample_content_alt.each { |data| Car.create!(data) }

      sample_csv = File.read("spec/support/csv/multi_only.csv")
      constructed_csv = ActiveReport::Record.export(Car.all, only: [:id, :name])

      expect(constructed_csv).to eq(sample_csv)
    end

    it "record" do
      Car.create!(sample_content)

      sample_csv = File.read("spec/support/csv/solo_only.csv")
      constructed_csv = ActiveReport::Record.export(Car.first, only: :name)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv except values for an" do
    it "array of records" do
      sample_content_alt.each { |data| Car.create!(data) }

      sample_csv = File.read("spec/support/csv/multi_except.csv")
      constructed_csv = ActiveReport::Record.export(Car.all, except: [:id, :name])

      expect(constructed_csv).to eq(sample_csv)
    end

    it "record" do
      Car.create!(sample_content)

      sample_csv = File.read("spec/support/csv/solo_except.csv")
      constructed_csv = ActiveReport::Record.export(Car.first, except: :name)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv with headers for an" do
    it "array of records" do
      sample_content_alt.each { |data| Car.create!(data) }

      sample_csv = File.read("spec/support/csv/multi_headers.csv")
      constructed_csv = ActiveReport::Record.export(Car.all, headers: sample_header_alt)

      expect(constructed_csv).to eq(sample_csv)
    end

    it "record" do
      Car.create!(sample_content)

      sample_csv = File.read("spec/support/csv/solo_headers.csv")
      constructed_csv = ActiveReport::Record.export(Car.first, headers: sample_header_alt)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv with options for an" do
    it "array of records" do
      sample_content_alt.each { |data| Car.create!(data) }

      sample_csv = File.read("spec/support/csv/multi_options.csv")
      constructed_csv = ActiveReport::Record.export(Car.all, options: { col_sep: ";" })

      expect(constructed_csv).to eq(sample_csv)
    end

    it "record" do
      Car.create!(sample_content)

      sample_csv = File.read("spec/support/csv/solo_options.csv")
      constructed_csv = ActiveReport::Record.export(Car.first, options: { col_sep: ";" })

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "import csv without headers returns an" do
    it "array of hashes" do
      constructed_array = ActiveReport::Record.import("spec/support/csv/multi_all.csv", model: Car)

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array with a hash" do
      constructed_array = ActiveReport::Record.import("spec/support/csv/solo_all.csv", model: Car)

      expect(constructed_array).to eq([].push(sample_content))
    end
  end

  context "import csv with headers returns an" do
    it "array of records" do
      constructed_array = ActiveReport::Record.import("spec/support/csv/multi_headerless.csv", model: Car, headers: sample_header_id)

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array with a record" do
      constructed_array = ActiveReport::Record.import("spec/support/csv/solo_headerless.csv", model: Car, headers: sample_header_id)

      expect(constructed_array).to eq([].push(sample_content))
    end
  end

  context "import csv only values returns an" do
    it "array of records" do
      sample_array = sample_content_alt_id.dup.map { |v| v.dup.keep_if { |k,v| [:name].include?(k) } }
      constructed_array = ActiveReport::Record.import("spec/support/csv/multi_headerless.csv", model: Car, headers: sample_header_id, only: :name)

      expect(constructed_array).to eq(sample_array)
    end

    it "array with a record" do
      sample_array = sample_content_id.dup.keep_if { |k,v| [:name].include?(k) }
      constructed_array = ActiveReport::Record.import("spec/support/csv/solo_headerless.csv", model: Car, headers: sample_header_id, only: :name)

      expect(constructed_array).to eq([].push(sample_array))
    end
  end

  context "import csv except values returns an" do
    it "array of records" do
      sample_array = sample_content_alt.dup.map { |v| v.dup.delete_if { |k,v| [:name].include?(k) } }
      constructed_array = ActiveReport::Record.import("spec/support/csv/multi_headerless.csv", model: Car, headers: sample_header_id, except: :name)

      expect(constructed_array).to eq(sample_array)
    end

    it "array with a record" do
      sample_array = sample_content.dup.delete_if { |k,v| [:name].include?(k) }
      constructed_array = ActiveReport::Record.import("spec/support/csv/solo_headerless.csv", model: Car, headers: sample_header_id, except: :name)

      expect(constructed_array).to eq([].push(sample_array))
    end
  end

  context "import csv with options returns an" do
    it "array of records" do
      constructed_array = ActiveReport::Record.import("spec/support/csv/multi_headerless_options.csv", model: Car, headers: sample_header_id, options: { col_sep: ";" })

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array with a record" do
      constructed_array = ActiveReport::Record.import("spec/support/csv/solo_headerless_options.csv", model: Car, headers: sample_header_id, options: { col_sep: ";" })

      expect(constructed_array).to eq([].push(sample_content))
    end
  end

end
