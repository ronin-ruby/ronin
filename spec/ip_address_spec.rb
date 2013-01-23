require 'spec_helper'

require 'ronin/ip_address'

describe IPAddress do
  let(:example_domain) { 'localhost' }
  let(:example_ip) { '127.0.0.1' }

  subject { described_class.new(address: example_ip) }

  it "should require an address" do
    ip_address = described_class.new

    expect(ip_address).not_to be_valid
  end

  describe "extract" do
    subject { described_class }

    let(:ip1)  { subject.parse('127.0.0.1') }
    let(:ip2)  { subject.parse('10.1.1.1') }
    let(:text) { "Hosts: #{ip1}, #{ip2}" }

    it "should extract multiple IP Addresses from text" do
      expect(subject.extract(text)).to eq([ip1, ip2])
    end

    it "should yield the extracted IPs if a block is given" do
      ip_addresses = []

      subject.extract(text) { |ip| ip_addresses << ip }

      expect(ip_addresses).to eq([ip1, ip2])
    end
  end

  describe "lookup" do
    subject { described_class }

    it "should lookup host-names to IP Addresses" do
      ip_addresses = subject.lookup(example_domain)
      addresses    = ip_addresses.map { |ip| ip.address }
      
      expect(addresses).to include(example_ip)
    end

    it "should associate the IP addresses with the original host name" do
      ip_addresses = subject.lookup(example_domain)
      host_names   = ip_addresses.map { |ip| ip.host_names[0].address }
      
      expect(host_names).to include(example_domain)
    end

    let(:bad_domain) { 'foo' }

    it "should return an empty Array for unknown domain names" do
      ip_addresses = subject.lookup(bad_domain)
      
      expect(ip_addresses).to be_empty
    end
  end

  describe "#lookup!" do
    it "should reverse lookup the host-name for an IP Address" do
      host_names = subject.lookup!
      addresses  = host_names.map { |host_name| host_name.address }
      
      expect(addresses).to include(example_domain)
    end

    it "should associate the host names with the original IP address" do
      host_names   = subject.lookup!
      ip_addresses = host_names.map do |host_name|
        host_name.ip_addresses[0].address
      end

      expect(ip_addresses).to include(subject)
    end

    let(:bad_ip) { '0.0.0.0' }

    it "should return an empty Array for unknown domain names" do
      ip_address = described_class.new(address: bad_ip)
      host_names = ip_address.lookup!

      expect(host_names).to be_empty
    end
  end

  describe "#version" do
    it "should only accept 4 or 6" do
      ip_address = described_class.new(address: '1.1.1.1', version: 7)

      expect(ip_address).not_to be_valid
    end

    context "with IPv4 address" do
      subject { described_class.new(address: '127.0.0.1') }

      it { expect(subject.version).to be == 4 }
    end

    context "with IPv6 address" do
      subject { described_class.new(address: '::1') }

      it { expect(subject.version).to be == 6 }
    end
  end
end
