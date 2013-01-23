require 'spec_helper'
require 'model/models/authored_model'

require 'ronin/model/has_authors'

describe Model::HasAuthors do
  let(:model) { AuthoredModel }

  before(:all) { AuthoredModel.auto_migrate! }

  describe ".included" do
    subject { model }

    it "should include Ronin::Model" do
      expect(subject.ancestors).to include(Model)
    end

    it "should define an authors relationship" do
      relationship = subject.relationships['authors']

      expect(relationship).not_to be_nil
      expect(relationship.child_model).to eq(Author)
    end

    it "should define relationships with Author" do
      relationship = Author.relationships['authored_models']

      expect(relationship).not_to be_nil
      expect(relationship.child_model).to eq(subject)
    end
  end

  let(:author_name) { 'Alice' }
  let(:author_email) { 'alice@example.com' }
  let(:organization) { 'Org' }

  describe "#author" do
    subject do
      model.new.tap do |resource|
        resource.author(name: author_name, email: author_email)
      end
    end

    it "should allow adding authors to a resource" do
      expect(subject.authors).not_to be_empty
      expect(subject.authors[0].name).to be(author_name)
      expect(subject.authors[0].email).to be(author_email)
    end
  end

  describe ".written_by" do
    subject { model }

    before do
      resource = subject.new(:content => 'Test')
      resource.author(
        name: author_name,
        email: author_email,
        organization: organization
      )

      resource.save
    end

    it "should allow querying resources based on their Author" do
      resources = subject.written_by(author_name)

      expect(resources.length).to eq(1)
      expect(resources[0].authors[0].name).to be == author_name
    end

    it "should allow querying resources based on their Organization" do
      resources = subject.written_for(organization)

      expect(resources.length).to eq(1)
      expect(resources[0].authors[0].organization).to be == organization
    end

    after { subject.destroy }
  end
end
