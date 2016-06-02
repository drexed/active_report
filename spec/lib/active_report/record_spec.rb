require "spec_helper"

describe ActiveReport::Record do

  let(:sh1) { ["Name", "Speed", "Hp", "Crash safety rated", "Created at"] }
  let(:sh2) { ["No.", "Model", "Speed", "Horse Power", "Crash Safety Rated", "Driven On"] }
  let(:sh3) { ["Id", "Name", "Speed", "Hp", "Crash safety rated", "Created at"] }
  let(:sh4) { ["Id", "No.", "Model", "Speed", "Horse Power", "Crash Safety Rated", "Driven On"] }
  let(:sc1) { { name: "Porche", speed: "225", hp: "430", crash_safety_rated: "true", created_at: "2014-08-22T20:59:34.000Z" } }
  let(:sc2) {
    [
      { name: "Ferrari", speed: "235", hp: "630", crash_safety_rated: "true", created_at: "2014-08-23T20:59:34.000Z" },
      { name: "Lamborghini", speed: "245", hp: "720", crash_safety_rated: "true", created_at: "2014-08-24T20:59:34.000Z" },
      { name: "Bugatti", speed: "256", hp: "1001", crash_safety_rated: "false", created_at: "2014-08-25T20:59:34.000Z" }
    ]
  }
  let(:sc3) { { id: 1, name: "Porche", speed: "225", hp: "430", crash_safety_rated: "true", created_at: "2014-08-22T20:59:34.000Z" } }
  let(:sc4) {
    [
      { id: 1, name: "Ferrari", speed: "235", hp: "630",  crash_safety_rated: "true",  created_at: "2014-08-23T20:59:34.000Z" },
      { id: 2, name: "Lamborghini", speed: "245", hp: "720",  crash_safety_rated: "true",  created_at: "2014-08-24T20:59:34.000Z" },
      { id: 3, name: "Bugatti", speed: "256", hp: "1001", crash_safety_rated: "false", created_at: "2014-08-25T20:59:34.000Z" }
    ]
  }

  context "export to csv all data for an" do
    it "array of records" do
      sc2.each { |data| Car.create!(data) }

      sarr = File.read("spec/support/csv/multi_all.csv")
      ccsv = ActiveReport::Record.export(Car.all)

      expect(ccsv).to eq(sarr)
    end

    it "record" do
      Car.create!(sc1)

      sarr = File.read("spec/support/csv/solo_all.csv")
      ccsv = ActiveReport::Record.export(Car.first)

      expect(ccsv).to eq(sarr)
    end
  end

  context "export to csv only values for an" do
    it "array of records" do
      sc2.each { |data| Car.create!(data) }

      sarr = File.read("spec/support/csv/multi_only.csv")
      ccsv = ActiveReport::Record.export(Car.all, only: [:id, :name])

      expect(ccsv).to eq(sarr)
    end

    it "record" do
      Car.create!(sc1)

      sarr = File.read("spec/support/csv/solo_only.csv")
      ccsv = ActiveReport::Record.export(Car.first, only: :name)

      expect(ccsv).to eq(sarr)
    end
  end

  context "export to csv except values for an" do
    it "array of records" do
      sc2.each { |data| Car.create!(data) }

      sarr = File.read("spec/support/csv/multi_except.csv")
      ccsv = ActiveReport::Record.export(Car.all, except: [:id, :name])

      expect(ccsv).to eq(sarr)
    end

    it "record" do
      Car.create!(sc1)

      sarr = File.read("spec/support/csv/solo_except.csv")
      ccsv = ActiveReport::Record.export(Car.first, except: :name)

      expect(ccsv).to eq(sarr)
    end
  end

  context "export to csv with headers for an" do
    it "array of records" do
      sc2.each { |data| Car.create!(data) }

      sarr = File.read("spec/support/csv/multi_headers.csv")
      ccsv = ActiveReport::Record.export(Car.all, headers: sh2)

      expect(ccsv).to eq(sarr)
    end

    it "record" do
      Car.create!(sc1)

      sarr = File.read("spec/support/csv/solo_headers.csv")
      ccsv = ActiveReport::Record.export(Car.first, headers: sh2)

      expect(ccsv).to eq(sarr)
    end
  end

  context "export to csv with options for an" do
    it "array of records" do
      sc2.each { |data| Car.create!(data) }

      sarr = File.read("spec/support/csv/multi_options.csv")
      ccsv = ActiveReport::Record.export(Car.all, options: { col_sep: ";" })

      expect(ccsv).to eq(sarr)
    end

    it "record" do
      Car.create!(sc1)

      sarr = File.read("spec/support/csv/solo_options.csv")
      ccsv = ActiveReport::Record.export(Car.first, options: { col_sep: ";" })

      expect(ccsv).to eq(sarr)
    end
  end

  context "import csv without headers to create" do
    it "3 cars" do
      ActiveReport::Record.import("spec/support/csv/multi_all.csv", model: Car)

      expect(Car.count).to eq(3)
    end

    it "1 car" do
      ActiveReport::Record.import("spec/support/csv/solo_all.csv", model: Car)

      expect(Car.count).to eq(1)
    end
  end

  context "import csv with headers to create" do
    it "3 cars" do
      ActiveReport::Record.import("spec/support/csv/multi_headerless.csv", model: Car, headers: sh3)

      expect(Car.count).to eq(3)
    end

    it "1 car" do
      ActiveReport::Record.import("spec/support/csv/solo_headerless.csv", model: Car, headers: sh3)

      expect(Car.count).to eq(1)
    end
  end

  context "import csv only values to create" do
    it "3 cars" do
      sarr = sc4.dup.map { |v| v.dup.keep_if { |k,v| [:name].include?(k) } }
      ActiveReport::Record.import("spec/support/csv/multi_headerless.csv", model: Car, headers: sh3, only: :name)

      expect(Car.where.not(name: nil).count).to eq(3)
    end

    it "1 car" do
      sarr = sc3.dup.keep_if { |k,v| [:name].include?(k) }
      ActiveReport::Record.import("spec/support/csv/solo_headerless.csv", model: Car, headers: sh3, only: :name)

      expect(Car.where.not(name: nil).count).to eq(1)
    end
  end

  context "import csv except values to create" do
    it "3 cars" do
      sarr = sc2.dup.map { |v| v.dup.delete_if { |k,v| [:name].include?(k) } }
      ActiveReport::Record.import("spec/support/csv/multi_headerless.csv", model: Car, headers: sh3, except: :name)

      expect(Car.where(name: nil).count).to eq(3)
    end

    it "1 car" do
      sarr = sc1.dup.delete_if { |k,v| [:name].include?(k) }
      ActiveReport::Record.import("spec/support/csv/solo_headerless.csv", model: Car, headers: sh3, except: :name)

      expect(Car.where(name: nil).count).to eq(1)
    end
  end

  context "import csv with options to create" do
    it "3 cars" do
      ActiveReport::Record.import("spec/support/csv/multi_headerless_options.csv", model: Car, headers: sh3, options: { col_sep: ";" })

      expect(Car.count).to eq(3)
    end

    it "1 car" do
      ActiveReport::Record.import("spec/support/csv/solo_headerless_options.csv", model: Car, headers: sh3, options: { col_sep: ";" })

      expect(Car.count).to eq(1)
    end
  end

end
