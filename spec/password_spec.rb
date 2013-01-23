require 'spec_helper'

require 'ronin/password'

describe Password do
  let(:password) { 'secret' }

  subject { described_class.new(clear_text: password) }

  describe "validations" do
    it "should require a clear-text password" do
      pass = described_class.new
      expect(pass).not_to be_valid

      pass.clear_text = password
      expect(pass).to be_valid
    end
  end

  describe "#digest" do
    let(:salt) { 'foo' }

    it "should calculate the digest of the password" do
      digest = subject.digest(:sha1)
      
      expect(digest).to eq(Digest::SHA1.hexdigest(password))
    end

    it "should calculate the digest of the password and prepended salt" do
      digest = subject.digest(:sha1, prepend_salt: salt)
      
      expect(digest).to eq(Digest::SHA1.hexdigest(salt + password))
    end

    it "should calculate the digest of the password and appended salt" do
      digest = subject.digest(:sha1, append_salt: salt)
      
      expect(digest).to eq(Digest::SHA1.hexdigest(password + salt))
    end
  end

  describe "#to_s" do
    it "should include the password" do
      expect(subject.to_s).to eq(password)
    end
  end
end
