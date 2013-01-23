require 'spec_helper'
require 'model/models/base_model'
require 'model/models/inherited_model'

require 'ronin/model/model'

describe Model do
  let(:base_model) { BaseModel }
  let(:inherited_model) { InheritedModel }

  before(:all) do
    BaseModel.auto_migrate!
    InheritedModel.auto_migrate!
  end

  describe ".included" do
    subject { base_model }

    it "should have a default repository name" do
      expect(subject.default_repository_name).to eq(:default)
    end
  end

  describe ".new" do
    subject { base_model }

    it "should allow creating new instances of the model" do
      resource = subject.new(name: 'joe')

      expect(resource.name).to eq('joe')
    end

    context "when the model defines an initialize method" do
      subject { inherited_model }

      it "should call initialize when creating new instances of the model" do
        resource = subject.new(name: 'joe')

        expect(resource.name).to eq('joe')
        expect(resource.var).to eq(2)
      end
    end
  end

  describe ".create!" do
    subject { inherited_model }

    it "should call initialize when creating a new resource" do
      resource = subject.create!(name: 'jim')

      expect(resource.name).to eq('jim')
      expect(resource.var).to eq(2)

      resource.destroy
    end
  end

  describe ".first" do
    subject { inherited_model }

    before { subject.create!(name: 'bob') }

    it "should call initialize when loading from the database" do
      resource = subject.first(name: 'bob')

      expect(resource.name).to eq('bob')
      expect(resource.var).to eq(2)
    end

    after { subject.destroy }
  end
end
