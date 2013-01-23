require 'spec_helper'

require 'ronin/author'

describe Author do
  describe "#to_s" do
    subject { described_class.new(name: 'anonymous') }

    it "should return the name when their is no email" do
      expect(subject.to_s).to eq('anonymous')
    end

    context "when email is set" do
      subject do
        described_class.new(
          name:  'anonymous',
          email: 'anonymous@example.com'
        )
      end

      it "should return the name and email when both are present" do
        expect(subject.to_s).to eq('anonymous <anonymous@example.com>')
      end
    end
  end
end
