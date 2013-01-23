require 'spec_helper'

require 'ronin/email_address'

describe EmailAddress do
  let(:user)  { 'joe' }
  let(:host)  { 'example.com' }
  let(:email) { "#{user}@#{host}" }

  subject {
    described_class.new(
      user_name: {name: user},
      host_name: {address: host}
    )
  }

  describe "extract" do
    subject { described_class }

    let(:email1) { subject.parse('foo@bar.com') }
    let(:email2) { subject.parse('foo!bar@baz.com') }
    let(:text)   { "To: #{email1}, #{email2}." }

    it "should extract multiple email addresses from text" do
      expect(subject.extract(text)).to eq([email1, email2])
    end

    it "should yield the extracted email addresses if a block is given" do
      emails = []

      subject.extract(text) { |email| emails << email }

      expect(emails).to eq([email1, email2])
    end
  end

  describe "parse" do
    it "should parse email addresses" do
      email_address = described_class.parse(email)

      expect(email_address.user_name.name).to eq(user)
      expect(email_address.host_name.address).to eq(host)
    end

    it "should strip whitespace from emails" do
      email_address = described_class.parse("  #{email} ")

      expect(email_address.user_name.name).to eq(user)
      expect(email_address.host_name.address).to eq(host)
    end
  end

  describe "from" do
    it "should accept Strings" do
      email_address = described_class.from(email)

      expect(email_address.user_name.name).to eq(user)
      expect(email_address.host_name.address).to eq(host)
    end

    it "should accept URI::MailTo objects" do
      uri = URI("mailto:#{email}")
      email_address = described_class.from(uri)

      expect(email_address.user_name.name).to eq(user)
      expect(email_address.host_name.address).to eq(host)
    end
  end

  it "should provide the user-name" do
    expect(subject.user).to eq(user)
  end

  it "should provide the host-name" do
    expect(subject.host).to eq(host)
  end

  describe "#to_s" do
    it "should include the email address" do
      expect(subject.to_s).to eq(email)
    end
  end
end
