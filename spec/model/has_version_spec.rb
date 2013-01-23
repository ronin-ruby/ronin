require 'spec_helper'
require 'model/models/versioned_model'

require 'ronin/model/has_version'

describe Model::HasVersion do
  let(:model) { VersionedModel }

  before(:all) { VersionedModel.auto_migrate! }

  describe ".included" do
    subject { model }

    it "should include Ronin::Model" do
      expect(subject.ancestors).to include(Model)
    end

    it "should define a version property" do
      expect(subject.properties).to be_named(:version)
    end

    it "should default the version property to '0.1'" do
      resource = subject.new

      expect(resource.version).to eq('0.1')
    end
  end

  describe ".revision" do
    subject { model }

    before do
      subject.create(
        version: '1.1',
        content: 'one'
      )

      subject.create(
        version: '1.1',
        content: 'two'
      )

      subject.create(
        version: '1.2',
        content: 'three'
      )
    end

    it "should allow querying specific revisions" do
      resources = subject.revision('1.1')

      expect(resources.length).to eq(2)
      expect(resources[0].version).to eq('1.1')
      expect(resources[0].content).to eq('one')

      expect(resources[1].version).to eq('1.1')
      expect(resources[1].content).to eq('two')
    end

    after { subject.destroy }
  end

  describe ".latest" do
    subject { model }

    before do
      subject.create(
        version: '1.0',
        content: 'foo'
      )

      subject.create(
        version: '1.5',
        content: 'foo'
      )

      subject.create(
        version: '1.1',
        content: 'foo'
      )
    end

    it "should allow querying the latest revision" do
      resource = subject.all(content: 'foo').latest

      expect(resource.version).to eq('1.5')
    end
  end
end
