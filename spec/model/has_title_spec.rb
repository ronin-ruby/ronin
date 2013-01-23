require 'spec_helper'
require 'model/models/titled_model'

require 'ronin/model/has_title'

describe Model::HasTitle do
  let(:model) { TitledModel }

  before(:all) { TitledModel.auto_migrate! }

  describe ".included" do
    subject { model }

    it "should include Ronin::Model" do
      expect(subject.ancestors).to include(Model)
    end

    it "should define a title property" do
      expect(subject.properties).to be_named(:title)
    end
  end

  describe ".titled" do
    subject { model }

    let(:title1) { 'Foo one' }
    let(:title2) { 'Foo bar two' }

    before do
      subject.create!(title: title1)
      subject.create!(title: title2)
    end

    it "should be able to find resources with similar titles" do
      resources = subject.titled('Foo')

      expect(resources.length).to eq(2)
      expect(resources[0].title).to be == title1
      expect(resources[1].title).to be == title2
    end

    after { subject.destroy }
  end
end
