require 'spec_helper'

require 'ronin/credential'

describe Credential do
  let(:name)     { 'alice'  }
  let(:password) { 'secret' }

  subject do
    described_class.new(
      user_name: {name: name},
      password:  {clear_text: password}
    )
  end

  it "should provide the user-name" do
    expect(subject.user).to eq(name)
  end

  it "should provide the clear-text password" do
    expect(subject.clear_text).to eq(password)
  end

  describe "#to_s" do
    it "should include the user name and password" do
      expect(subject.to_s).to eq("#{name}:#{password}")
    end
  end
end
