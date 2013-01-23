require 'spec_helper'
require 'classes/my_script'
require 'helpers/repositories'

require 'ronin/script'

describe Script do
  include Helpers::Repositories

  subject { MyScript }

  before(:all) { MyScript.auto_migrate! }

  let(:repo) { repository('scripts') }

  before { repo.cache_scripts! }

  it "should be a Model" do
    expect(subject.included_modules).to include(Model)
  end

  it "should have a name" do
    expect(subject.included_modules).to include(Model::HasName)
  end

  it "should have a description" do
    expect(subject.included_modules).to include(Model::HasDescription)
  end

  it "should have a version" do
    expect(subject.included_modules).to include(Model::HasVersion)
  end

  it "should include ObjectLoader" do
    expect(subject.included_modules).to include(ObjectLoader)
  end

  it "should include DataPaths::Finders" do
    expect(subject.included_modules).to include(DataPaths::Finders)
  end

  it "should include Parameters" do
    expect(subject.included_modules).to include(Parameters)
  end

  it "should include UI::Printing" do
    expect(subject.included_modules).to include(UI::Printing)
  end

  it "should add the type property to the model" do
    expect(subject.properties).to be_named(:type)
  end

  it "should add a relation between Script::Path and the script" do
    expect(subject.relationships).to be_named(:script_path)
  end

  describe "#initialize" do
    it "should initialize attributes" do
      resource = subject.new(name: 'test')

      expect(resource.name).to eq('test')
    end

    it "should initialize parameters" do
      resource = subject.new(x: 5)

      expect(resource.x).to eq(5)
    end

    it "should allow custom initialize methods" do
      resource = subject.new

      expect(resource.var).to eq(2)
    end
  end

  it "should have an short-name" do
    expect(subject.short_name).to eq('MyScript')
  end

  describe "load_from" do
    let(:path) { repo.find_script('my_scripts/test.rb').path }

    subject { Script.load_from(path) }

    it "should have a script_path resource" do
      expect(subject.script_path).not_to be_nil
    end

    it "should prepare the object to be cached" do
      expect(subject.content).to eq('this is a test')
    end

    it "should preserve instance variables" do
      expect(subject.var).to eq(2)
    end

    it "should preserve instance methods" do
      expect(subject.greeting).to eq('hello')
    end

    it "should load the script source" do
      expect(subject).to be_script_loaded
    end
  end

  context "when previously cached" do
    subject { MyScript.first(name: 'test') }

    it "should have a cached_file resource" do
      expect(subject.script_path).not_to be_nil
    end

    it "should be able to load the script source" do
      subject.load_script!

      expect(subject.greeting).to eq('hello')
    end

    it "should only load the script source once" do
      subject.load_script!

      subject.var = false
      subject.load_script!

      expect(subject.var).to be(false)
    end
  end
end
