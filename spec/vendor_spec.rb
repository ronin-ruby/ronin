require 'spec_helper'

require 'ronin/vendor'

describe Vendor do
  let(:name) { 'TestCo' }

  subject { described_class.new(name: name) }

  describe "validations" do
    it "should require name attribute" do
      product = described_class.new
      expect(product).not_to be_valid

      product.name = name
      expect(product).to be_valid
    end
  end

  describe "#to_s" do
    it "should include the vendor name" do
      expect(subject.to_s).to eq(name)
    end
  end
end
