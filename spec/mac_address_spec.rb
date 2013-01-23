require 'spec_helper'

require 'ronin/mac_address'

describe MACAddress do
  let(:address) { '00:01:02:03:04:05' }

  subject { described_class.new(address: address) }

  describe "extract" do
    subject { described_class }

    let(:mac1) { subject.parse('00:12:34:56:78:9a') }
    let(:mac2) { subject.parse('AA:BB:CC:DD:EE:FF') }
    let(:text)  { "MACs: #{mac1}, #{mac2}." }

    it "should extract multiple MAC Addresses from text" do
      expect(subject.extract(text)).to eq([mac1, mac2])
    end

    it "should yield the extracted MAC Addresses if a block is given" do
      macs = []

      subject.extract(text) { |mac| macs << mac }

      expect(macs).to eq([mac1, mac2])
    end
  end

  describe "validations" do
    it "should require an address" do
      mac = described_class.new
      expect(mac).not_to be_valid

      mac.address = address
      expect(mac).to be_valid
    end
  end

  describe "#to_i" do
    let(:integer) { 0x000102030405 }

    it "should convert the MAC Address to an Integer" do
      expect(subject.to_i).to eq(integer)
    end
  end
end
