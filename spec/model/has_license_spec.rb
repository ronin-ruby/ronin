require 'spec_helper'
require 'model/models/licensed_model'

require 'ronin/model/has_license'

describe Model::HasLicense do
  let(:model) { LicensedModel }

  before(:all) { LicensedModel.auto_migrate! }

  describe ".included" do
    subject { model }

    it "should include Ronin::Model" do
      expect(subject.ancestors).to include(Model)
    end

    it "should define a license relationship" do
      relationship = subject.relationships['license']

      expect(relationship).not_to be_nil
      expect(relationship.parent_model).to eq(License)
    end

    it "should define relationships with License" do
      relationship = License.relationships['licensed_models']

      expect(relationship).not_to be_nil
      expect(relationship.child_model).to eq(subject)
    end
  end

  describe "validations" do
    subject { model }

    it "should not require a license" do
      resource = subject.new(content: 'bla')

      expect(resource).to be_valid
    end
  end

  describe ".licensed_under" do
    subject { model }

    before do
      subject.create(
        content: 'stuff here',
        license: License.gpl2
      )
    end

    let(:license) { License.gpl2 }

    it "should accept License resources" do
      resource = subject.licensed_under(license).first

      expect(resource.license).to be == license
    end

    it "should accept the names of predefined Licenses" do
      resource = subject.licensed_under(:gpl2).first

      expect(resource.license).to be == license
    end

    it "should accept the names of licenses" do
      resource = subject.licensed_under('GPL-2').first

      expect(resource.license).to be == license
    end

    after { subject.destroy }
  end
end
