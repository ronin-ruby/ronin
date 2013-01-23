require 'spec_helper'

require 'ronin/software'

describe Software do
  let(:name)    { 'Test'  }
  let(:version) { '0.1.0' }
  let(:vendor)  { 'TestCo' }

  subject do
    described_class.new(
      name:    name,
      version: version,
      vendor:  {name: vendor}
    )
  end

  describe "validations" do
    it "should require name and version attributes" do
      software = described_class.new
      expect(software).not_to be_valid

      software.name = name
      expect(software).not_to be_valid

      software.version = version
      expect(software).to be_valid
    end
  end

  describe "#to_s" do
    it "should be convertable to a String" do
      expect(subject.to_s).to eq("#{vendor} #{name} #{version}")
    end

    context "without a vendor" do
      subject do
        described_class.new(name: name, version: version)
      end

      it "should ignore the missing vendor information" do
        expect(subject.to_s).to eq("#{name} #{version}")
      end
    end
  end
end
