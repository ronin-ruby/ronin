require 'spec_helper'

require 'ronin/port'

describe Port do
  let(:protocol) { 'tcp' }
  let(:number)   { 80    }

  subject do
    described_class.new(protocol: protocol, number: number)
  end

  before { subject.save }

  describe "validations" do
    it "should require a protocol" do
      port = described_class.new(number: port)

      expect(port).not_to be_valid
    end

    it "should require a port number" do
      port = described_class.new(protocol: protocol)

      expect(port).not_to be_valid
    end

    it "should only allow 'tcp' and 'udp' as protocols" do
      port = described_class.new(protocol: 'foo', number: port)

      expect(port).not_to be_valid
    end

    it "should require unique protocol/port-number combinations" do
      port = described_class.new(protocol: protocol, number: number)
      expect(port).not_to be_valid
    end
  end

  describe "#to_i" do
    it "should be convertable to an Integer" do
      expect(subject.to_i).to eq(number)
    end
  end

  describe "#to_s" do
    it "should include the number and protocol" do
      expect(subject.to_s).to eq("#{number}/#{protocol}")
    end
  end
end
