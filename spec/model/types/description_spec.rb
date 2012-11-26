require 'spec_helper'

describe Model::Types::Description do
  class DescriptionModel

    include Ronin::Model

    property :id, Serial

    property :description, Types::Description

  end

  subject { DescriptionModel.properties[:description] }

  describe "typecast" do
    context "when given nil" do
      it "should return nil" do
        subject.typecast(nil).should == nil
      end
    end

    context "when given a single-line String" do
      let(:string)    { '  foo  '    }
      let(:sanitized) { string.strip }

      it "should strip leading and trailing whitespace" do
        subject.typecast(string).should == sanitized
      end
    end

    context "when given a multi-line String" do
      let(:lines) do
        [
          '',
          '  foo  ',
          '  bar  ',
          '  baz  ',
          ''
        ]
      end

      let(:string)    { lines.join($/)                    }
      let(:sanitized) { lines.map(&:strip).join($/).strip }

      it "should strip leading and trailing whitespace from each line" do
        subject.typecast(string).should == sanitized
      end
    end
  end
end
