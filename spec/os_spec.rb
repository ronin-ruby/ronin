require 'spec_helper'

require 'ronin/os'

describe OS do
  let(:name)    { 'Linux'  }
  let(:version) { '2.6.11' }

  subject { described_class.new(name: name, version: version) }

  describe "predefine" do
    it "should provide methods for built-in described_classes" do
      os = described_class.linux

      expect(os.name).to eq('Linux')
    end

    it "should provide methods for creating described_classes with versions" do
      os = described_class.linux(version)

      expect(os.version).to eq(version)
    end
  end

  describe "validations" do
    it "should require a name" do
      os = described_class.new
      expect(os).not_to be_valid

      os.name = 'test'
      expect(os).to be_valid
    end
  end

  describe "#to_s" do
    it "should convert both the name and version" do
      expect(subject.to_s).to eq("#{name} #{version}")
    end

    context "without a version" do
      subject { described_class.new(name: name) }

      it "should convert just the name if there is no version" do
        expect(subject.to_s).to eq(name)
      end
    end
  end
end
