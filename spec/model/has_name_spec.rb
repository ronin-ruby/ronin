require 'spec_helper'
require 'model/models/named_model'

require 'ronin/model/has_name'

describe Model::HasName do
  let(:model) { NamedModel }

  before(:all) { NamedModel.auto_migrate! }

  describe ".included" do
    subject { model }

    it "should include Ronin::Model" do
      expect(subject.ancestors).to include(Model)
    end

    it "should define a name property" do
      expect(subject.properties).to be_named(:name)
    end
  end

  describe "validations" do
    subject { model }

    it "should require a name" do
      resource = subject.new
      expect(resource).not_to be_valid

      resource.name = 'foo'
      expect(resource).to be_valid
    end
  end

  describe ".named" do
    subject { model }

    let(:name1) { 'foo1' }
    let(:name2) { 'foo2' }

    before do
      subject.create!(name: name1)
      subject.create!(name: name2)
    end

    it "should be able to find resources with similar names" do
      resources = subject.named('foo')

      expect(resources.length).to eq(2)
      expect(resources[0].name).to be == name1
      expect(resources[1].name).to be == name2
    end

    after { subject.destroy }
  end
end
