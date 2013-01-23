require 'spec_helper'
require 'helpers/repositories'
require 'classes/my_script'

require 'ronin/script/path'

describe Script::Path do
  include Helpers::Repositories

  let(:repo) { repository('scripts') }
  let(:script_class) { MyScript }

  before(:all) { MyScript.auto_migrate! }

  before { repo.cache_scripts! }

  describe "cached file" do
    subject { repo.find_script('cached/cached.rb') }

    it "should be saved" do
      expect(subject).to be_saved
    end

    it "should have a path" do
      expect(subject.path).not_to be_nil
    end

    it "should have a timestamp" do
      expect(subject.timestamp).not_to be_nil
    end

    it "should not have updated code" do
      expect(subject).not_to be_updated
    end

    it "should not have cache exceptions" do
      expect(subject.cache_exception).to be_nil
    end

    it "should not have cache errors" do
      expect(subject.cache_errors).to be_nil
    end

    it "should have the model name of the cached object" do
      expect(subject.class_name).to eq(script_class.name)
    end

    it "should have the model path of the cached object" do
      expect(subject.class_path).to eq('my_script')
    end

    it "should be able to load the Model of the cached object" do
      expect(subject.script_class).to eq(script_class)
    end

    it "should be able to load a fresh model from the cached file" do
      obj = subject.load_script

      expect(obj).not_to be_nil
      expect(obj.class).to eq(script_class)
    end

    it "should cache the loaded object along with the cached file" do
      obj = script_class.first(script_path: subject)
      
      expect(obj).not_to be_nil
    end

    it "should be able to load the cached object" do
      expect(subject.cached_script).not_to be_nil
      expect(subject.cached_script.class).to eq(script_class)
    end

    it "should call the cache method before saving the new object" do
      expect(subject.cached_script.name).to eq('cached')
    end

    it "should delete the cached object along with the cached file" do
      subject.destroy

      expect(script_class.first(script_path: subject)).to be_nil
    end
  end

  describe "failed cached files" do
    let(:syntax_error) { repo.find_script('failures/syntax_errors.rb') }
    let(:load_error) { repo.find_script('failures/load_errors.rb') }
    let(:name_error) { repo.find_script('failures/name_errors.rb') }
    let(:no_method_error) { repo.find_script('failures/no_method_errors.rb') }
    let(:exception) { repo.find_script('failures/exceptions.rb') }
    let(:validation_error) { repo.find_script('failures/validation_errors.rb') }

    it "should not save new cached files that raised exceptions" do
      expect(syntax_error).not_to be_saved
      expect(load_error).not_to be_saved
      expect(exception).not_to be_saved
    end

    pending "https://github.com/ronin-rb/ronin/issues/7" do
      it "should not save new cached files that contain validation errors" do
        expect(validation_error).to_not be_saved
      end
    end

    it "should store syntax errors" do
      expect(syntax_error.cache_exception).not_to be_nil
      expect(syntax_error.cache_exception.class).to eq(SyntaxError)
    end

    it "should store LoadError exceptions" do
      expect(load_error.cache_exception).not_to be_nil
      expect(load_error.cache_exception.class).to eq(LoadError)
    end

    it "should store NameError exceptions" do
      expect(name_error.cache_exception).not_to be_nil
      expect(name_error.cache_exception.class).to eq(NameError)
    end

    it "should store NoMethodError exceptions" do
      expect(no_method_error.cache_exception).not_to be_nil
      expect(no_method_error.cache_exception.class).to eq(NoMethodError)
    end

    it "should store Exceptions raised when creating the fresh object" do
      expect(exception.cache_exception).not_to be_nil
    end

    it "should store validation errors" do
      expect(validation_error.cache_errors).not_to be_nil
    end
  end

  describe "unmodified cached file" do
    subject { repo.find_script('cached/unmodified.rb') }

    it "should not have updated code" do
      should_not be_updated
    end

    it "should not re-cache unmodified files" do
      expect(subject.sync).to be(false)
    end

    it "should not have cache errors" do
      expect(subject.cache_errors).to be_nil
    end
  end

  describe "modified cached file" do
    subject { repo.find_script('cached/modified.rb') }

    before do
      subject.update(timestamp: (subject.timestamp - 10))
    end

    it "should not have updated code" do
      should be_updated
    end

    it "should re-cache modified files" do
      expect(subject.sync).to be(true)
    end

    it "should not have cache errors" do
      expect(subject.cache_errors).to be_nil
    end
  end

  describe "missing cached file" do
    subject { repo.find_script('cached/missing.rb') }

    before do
      subject.update(path: File.join('','missing','file.rb'))

      subject.sync
    end

    it "should delete the cached files" do
      expect(described_class.count(id: subject.id)).to eq(0)
    end

    it "should delete cached objects for missing files" do
      expect(script_class.count(script_path: subject)).to eq(0)
    end
  end
end
