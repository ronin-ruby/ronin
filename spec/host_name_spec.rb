require 'spec_helper'

require 'ronin/host_name'

describe HostName do
  let(:domain) { 'localhost' }
  let(:ip)     { '127.0.0.1' }

  subject { described_class.new(address: domain) }

  describe "validations" do
    it "should require an address" do
      host_name = described_class.new

      expect(host_name).not_to be_valid
    end
  end

  it "should alias #name to #address" do
    expect(subject.name).to eq(subject.address)
  end

  describe "extract" do
    subject { described_class }

    let(:host1) { subject.parse('www.example.com') }
    let(:host2) { subject.parse('1.2.3.4.in-addr.arpa') }
    let(:text)  { "Hosts: #{host1}, #{host2}." }

    it "should extract multiple host-names from text" do
      expect(subject.extract(text)).to eq([host1, host2])
    end

    it "should yield the extracted host-names if a block is given" do
      hosts = []

      subject.extract(text) { |host| hosts << host }

      expect(hosts).to eq([host1, host2])
    end
  end

  describe "lookup" do
    subject { described_class }

    it "should look up the host names for an IP Address" do
      host_names = subject.lookup(ip).map { |name| name.address }
      
      expect(host_names).to include(domain)
    end

    it "should associate the host names with the original IP address" do
      host_names = subject.lookup(ip)
      
      host_names.each do |host|
        expect(host.ip_addresses[0].address).to eq(ip)
      end
    end

    let(:bad_ip) { '0.0.0.0' }

    it "should return an empty Array for unknown host names" do
      host_names = subject.lookup(bad_ip)
      
      expect(host_names).to be_empty
    end
  end

  describe "#lookup!" do
    it "should look up the IP Addresses for the host name" do
      ips = subject.lookup!
      
      expect(ips.any? { |ip_address| ip_address.address == ip }).to be(true)
    end

    it "should associate the IP addresses with the original host name" do
      ips = subject.lookup!
      
      ips.each do |ip_address|
        expect(ip_address.host_names[0].address).to eq(domain)
      end
    end

    let(:bad_domain) { 'foo' }

    it "should return an empty Array for unknown host names" do
      ips = described_class.new(address: bad_domain).lookup!
      
      expect(ips).to be_empty
    end
  end
end
