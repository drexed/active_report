require "spec_helper"

describe ActiveReport::Array do

  let(:sample_header) { ["Id", "Name", "Speed", "Hp", "Crash safety rated", "Created at"] }
  let(:sample_header_alt) { ["No.", "Model", "Speed", "Horse Power", "Crash Safety Rated", "Driven On"] }
  let(:sample_content) { ["1", "Porche", "225", "430", "true", "2014-08-22T20:59:34.000Z"] }
  let(:sample_content_alt) {
    [
      ["1", "Ferrari", "235", "630", "true", "2014-08-23T20:59:34.000Z"],
      ["2", "Lamborghini", "245", "720", "true", "2014-08-24T20:59:34.000Z"],
      ["3", "Bugatti", "256", "1001", "false", "2014-08-25T20:59:34.000Z"]
    ]
  }

  context "export to csv without headers for an" do
    it "array of arrays" do
      sample_csv = File.read("spec/support/csv/multi_headerless.csv")
      constructed_csv = ActiveReport::Array.export(sample_content_alt)

      expect(constructed_csv).to eq(sample_csv)
    end

    it "array" do
      sample_csv = File.read("spec/support/csv/solo_headerless.csv")
      constructed_csv = ActiveReport::Array.export(sample_content)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv with headers for an" do
    it "array of arrays" do
      sample_csv = File.read("spec/support/csv/multi_headers.csv")
      constructed_csv = ActiveReport::Array.export(sample_content_alt, headers: sample_header_alt)

      expect(constructed_csv).to eq(sample_csv)
    end

    it "array" do
      sample_csv = File.read("spec/support/csv/solo_headers.csv")
      constructed_csv = ActiveReport::Array.export(sample_content, headers: sample_header_alt)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv with options for an" do
    it "array of arrays" do
      sample_csv = File.read("spec/support/csv/multi_options.csv")
      constructed_csv = ActiveReport::Array.export(sample_content_alt, headers: sample_header, options: { col_sep: ";" })

      expect(constructed_csv).to eq(sample_csv)
    end

    it "array" do
      sample_csv = File.read("spec/support/csv/solo_options.csv")
      constructed_csv = ActiveReport::Array.export(sample_content, headers: sample_header, options: { col_sep: ";" })

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "import csv without headers returns an" do
    it "array of arrays" do
      constructed_array = ActiveReport::Array.import("spec/support/csv/multi_headerless.csv")

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array" do
      constructed_array = ActiveReport::Array.import("spec/support/csv/solo_headerless.csv")

      expect(constructed_array).to eq(sample_content)
    end
  end

  context "import csv with headers returns an" do
    it "array of arrays" do
      constructed_array = ActiveReport::Array.import("spec/support/csv/multi_headerless.csv", headers: sample_header)

      expect(constructed_array).to eq(sample_content_alt.dup.unshift(sample_header))
    end

    it "array" do
      constructed_array = ActiveReport::Array.import("spec/support/csv/solo_headerless.csv", headers: sample_header)

      expect(constructed_array).to eq([].push(sample_header).push(sample_content))
    end
  end

  context "import csv with options returns an" do
    it "array of arrays" do
      constructed_array = ActiveReport::Array.import("spec/support/csv/multi_options.csv", options: { col_sep: ";" })

      expect(constructed_array).to eq([].push(sample_header).concat(sample_content_alt))
    end

    it "array" do
      constructed_array = ActiveReport::Array.import("spec/support/csv/solo_options.csv", options: { col_sep: ";" })

      expect(constructed_array).to eq([].push(sample_header).push(sample_content))
    end
  end

end
