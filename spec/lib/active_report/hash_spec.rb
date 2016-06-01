require "spec_helper"

describe ActiveReport::Hash do

  let(:sample_header) { ["Id", "Name", "Speed", "Hp", "Crash safety rated", "Created at"] }
  let(:sample_header_alt) { ["No.", "Model", "Speed", "Horse Power", "Crash Safety Rated", "Driven On"] }
  let(:sample_content) {
    {
      "Id" => "1", "Name" => "Porche", "Speed" => "225", "Hp" => "430",
      "Crash safety rated" => "true", "Created at" => "2014-08-22T20:59:34.000Z"
    }
  }
  let(:sample_content_alt) {
    [
      {
        "Id" => "1", "Name" => "Ferrari", "Speed" => "235", "Hp" => "630",
        "Crash safety rated" => "true", "Created at" => "2014-08-23T20:59:34.000Z"
      },
      {
        "Id" => "2", "Name" => "Lamborghini", "Speed" => "245", "Hp" => "720",
        "Crash safety rated" => "true", "Created at" => "2014-08-24T20:59:34.000Z"
      },
      {
        "Id" => "3", "Name" => "Bugatti", "Speed" => "256", "Hp" => "1001",
        "Crash safety rated" => "false", "Created at" => "2014-08-25T20:59:34.000Z"
      }
    ]
  }

  context "export to csv all data for an" do
    it "array of hashes" do
      sample_csv = File.read("spec/support/csv/multi_all.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content_alt)

      expect(constructed_csv).to eq(sample_csv)
    end

    it "hash" do
      sample_csv = File.read("spec/support/csv/solo_all.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv only values for an" do
    it "array of hashes" do
      sample_csv = File.read("spec/support/csv/multi_only.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content_alt, only: ["Id", "Name"])

      expect(constructed_csv).to eq(sample_csv)
    end

    it "hash" do
      sample_csv = File.read("spec/support/csv/solo_only.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content, only: "Name")

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv except values for an" do
    it "array of hashes" do
      sample_csv = File.read("spec/support/csv/multi_except.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content_alt, except: ["Id", "Name"])

      expect(constructed_csv).to eq(sample_csv)
    end

    it "hash" do
      sample_csv = File.read("spec/support/csv/solo_except.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content, except: "Name")

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv with headers for an" do
    it "array of hashes" do
      sample_csv = File.read("spec/support/csv/multi_headers.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content_alt, headers: sample_header_alt)

      expect(constructed_csv).to eq(sample_csv)
    end

    it "hash" do
      sample_csv = File.read("spec/support/csv/solo_headers.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content, headers: sample_header_alt)

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "export to csv with options for an" do
    it "array of hashes" do
      sample_csv = File.read("spec/support/csv/multi_options.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content_alt, options: { col_sep: ";" })

      expect(constructed_csv).to eq(sample_csv)
    end

    it "hash" do
      sample_csv = File.read("spec/support/csv/solo_options.csv")
      constructed_csv = ActiveReport::Hash.export(sample_content, options: { col_sep: ";" })

      expect(constructed_csv).to eq(sample_csv)
    end
  end

  context "import csv without headers returns an" do
    it "array of hashes" do
      constructed_array = ActiveReport::Hash.import("spec/support/csv/multi_all.csv")

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array with a hash" do
      constructed_array = ActiveReport::Hash.import("spec/support/csv/solo_all.csv")

      expect(constructed_array).to eq([].push(sample_content))
    end
  end

  context "import csv with headers returns an" do
    it "array of hashes" do
      constructed_array = ActiveReport::Hash.import("spec/support/csv/multi_headerless.csv", headers: sample_header)

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array with a hash" do
      constructed_array = ActiveReport::Hash.import("spec/support/csv/solo_headerless.csv", headers: sample_header)

      expect(constructed_array).to eq([].push(sample_content))
    end
  end

  context "import csv only values returns an" do
    it "array of arrays" do
      sample_array = sample_content_alt.dup.map { |v| v.dup.keep_if { |k,v| ["Id", "Name"].include?(k) } }
      constructed_array = ActiveReport::Hash.import("spec/support/csv/multi_headerless.csv", headers: sample_header, only: ["Id", "Name"])

      expect(constructed_array).to eq(sample_array)
    end

    it "array with a hash" do
      sample_array = sample_content.dup.keep_if { |k,v| ["Name"].include?(k) }
      constructed_array = ActiveReport::Hash.import("spec/support/csv/solo_headerless.csv", headers: sample_header, only: "Name")

      expect(constructed_array).to eq([].push(sample_array))
    end
  end

  context "import csv except values returns an" do
    it "array of arrays" do
      sample_array = sample_content_alt.dup.map { |v| v.dup.delete_if { |k,v| ["Id", "Name"].include?(k) } }
      constructed_array = ActiveReport::Hash.import("spec/support/csv/multi_headerless.csv", headers: sample_header, except: ["Id", "Name"])

      expect(constructed_array).to eq(sample_array)
    end

    it "array with a hash" do
      sample_array = sample_content.dup.delete_if { |k,v| ["Name"].include?(k) }
      constructed_array = ActiveReport::Hash.import("spec/support/csv/solo_headerless.csv", headers: sample_header, except: "Name")

      expect(constructed_array).to eq([].push(sample_array))
    end
  end

  context "import csv with options returns an" do
    it "array of hashes" do
      constructed_array = ActiveReport::Hash.import("spec/support/csv/multi_headerless_options.csv", headers: sample_header, options: { col_sep: ";" })

      expect(constructed_array).to eq(sample_content_alt)
    end

    it "array with a hash" do
      constructed_array = ActiveReport::Hash.import("spec/support/csv/solo_headerless_options.csv", headers: sample_header, options: { col_sep: ";" })

      expect(constructed_array).to eq([].push(sample_content))
    end
  end

end
