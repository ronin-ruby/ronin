require 'spec_helper'

require 'ronin/url_query_param'

describe URLQueryParam do
  let(:name)  { 'foo' }
  let(:value) { 'bar' }

  subject do
    described_class.new(name: {name: name}, value: value)
  end

  describe "#to_s" do
    it "should dump a name and a value into a String" do
      expect(subject.to_s).to eq("#{name}=#{value}")
    end

    context "with empty or nil values" do
      subject do
        described_class.new(name: {name: name})
      end

      it "should ignore empty or nil values" do
        expect(subject.to_s).to eq("#{name}=")
      end
    end

    context "with special characters" do
      let(:value)         { 'bar baz'         }
      let(:encoded_value) { URI::DEFAULT_PARSER.escape(value) }

      subject do
        described_class.new(name: {name: name}, value: value)
      end

      it "should escape special characters" do
        expect(subject.to_s).to eq("#{name}=#{encoded_value}")
      end
    end
  end
end
