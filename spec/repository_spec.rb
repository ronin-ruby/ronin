require 'spec_helper'
require 'helpers/repositories'

require 'ronin/repository'

describe Repository do
  include Helpers::Repositories

  subject { described_class }

  describe "find" do
    it "should be able to retrieve an Repository by name" do
      repo = subject.find('local')

      expect(repo.name).to eq('local')
    end

    it "should be able to retrieve an Repository by name and domain" do
      repo = subject.find('installed@github.com')

      expect(repo.name).to eq('installed')
      expect(repo.domain).to eq('github.com')
    end

    it "should raise RepositoryNotFound for unknown Repository names" do
      expect {
        subject.find('bla')
      }.to raise_error(RepositoryNotFound)
    end

    it "should raise RepositoryNotFound for unknown Repository names or domains" do
      expect {
        subject.find('bla/bla')
      }.to raise_error(RepositoryNotFound)
    end
  end

  describe "add" do
    it "should not add Repositorys without a path property" do
      expect {
        subject.add
      }.to raise_error(ArgumentError)
    end

    it "should not add Repositorys that do not point to a directory" do
      expect {
        subject.add(path: 'path/to/nowhere')
      }.to raise_error(RepositoryNotFound)
    end

    it "should not allow adding an Repository from the same path twice" do
      expect {
        subject.add(path: repository('local').path)
      }.to raise_error(DuplicateRepository)
    end

    it "should not allow adding an Repository that was already installed" do
      expect {
        subject.add(path: repository('installed').path)
      }.to raise_error(DuplicateRepository)
    end
  end

  describe "install" do
    it "should not allow installing an Repository with no URI" do
      expect {
        subject.install
      }.to raise_error(ArgumentError)
    end

    it "should not allow installing an Repository that was already added" do
      expect {
        subject.install(uri: repository('remote').uri)
      }.to raise_error(DuplicateRepository)
    end

    it "should not allow installing an Repository from the same URI twice" do
      expect {
        subject.install(uri: repository('installed').uri)
      }.to raise_error(DuplicateRepository)
    end
  end

  describe "#domain" do
    it "should be considered local for 'localhost' domains" do
      repo = repository('local')

      expect(repo).to be_local
      expect(repo).not_to be_remote
    end

    it "should be considered remote for non 'localhost' domains" do
      repo = repository('installed')

      expect(repo).to be_remote
      expect(repo).not_to be_local
    end
  end

  describe "#initialize" do
    it "should default the 'name' property to the name of the Repository directory" do
      repo = subject.new(
        path: File.join(Helpers::Repositories::DIR,'local')
      )

      expect(repo.name).to eq('local')
    end

    it "should default the 'installed' property to false" do
      repo = subject.new(
        path: File.join(Helpers::Repositories::DIR,'local'),
        uri: 'git://github.com/path/to/local.git'
      )

      expect(repo.installed).to be(false)
    end
  end

  describe "#initialize_metadata" do
    subject { repository('installed') }

    it "should load the title" do
      expect(subject.title).to eq('Installed Repo')
    end

    it "should load the website" do
      website = Addressable::URI.parse('http://ronin.rubyforge.org/')

      expect(subject.website).to eq(website)
    end

    it "should load the license" do
      expect(subject.license).not_to be_nil
      expect(subject.license.name).to eq('GPL-2')
    end

    it "should load the maintainers" do
      author = subject.authors.find { |author|
        author.name == 'Postmodern' &&
        author.email == 'postmodern.mod3@gmail.com'
      }
      
      expect(author).not_to be_nil
    end

    it "should load the description" do
      expect(subject.description).to eq(%{This is a test repo used in Ronin's specs.})
    end
  end

  describe "#activate!" do
    subject { repository('local') }

    before { subject.activate! }

    it "should load the init.rb file if present" do
      expect($local_repo_loaded).to be(true)
    end

    it "should make the lib directory accessible to Kernel#require" do
      expect(require('stuff/test')).to be(true)
    end

    after { subject.deactivate! }
  end

  describe "#deactivate!" do
    subject { repository('local') }

    before do
      subject.activate!
      subject.deactivate!
    end

    it "should make the lib directory unaccessible to Kernel#require" do
      expect {
        require 'stuff/another_test'
      }.to raise_error(LoadError)
    end
  end

  describe "#each_script" do
    subject { repository('scripts') }

    it "should list the contents of the 'cache/' directory" do
      expect(subject.each_script.to_a).not_to be_empty
    end

    it "should only list '.rb' files" do
      expect(subject.each_script.map { |path|
        path.extname
      }.uniq).to eq(['.rb'])
    end
  end

  describe "#script_paths" do
    subject { repository('scripts') }

    describe "#cache_scripts!" do
      before { subject.cache_scripts! }

      it "should be populated script_paths" do
        expect(subject.script_paths).not_to be_empty
      end

      it "should recover from files that contain syntax errors" do
        expect(subject.find_script('failures/syntax_errors.rb')).not_to be_nil
      end

      it "should recover from files that raised exceptions" do
        expect(subject.find_script('failures/exceptions.rb')).not_to be_nil
      end

      it "should recover from files that raise NoMethodError" do
        expect(subject.find_script('failures/no_method_errors.rb')).not_to be_nil
      end

      it "should recover from files that have validation errors" do
        expect(subject.find_script('failures/validation_errors.rb')).not_to be_nil
      end

      it "should clear script_paths before re-populate them" do
        paths = subject.script_paths.length
        subject.cache_scripts!

        expect(subject.script_paths.length).to eq(paths)
      end

      it "should be populated using the paths in the 'cache/' directory" do
        expect(subject.script_paths.map { |file|
          file.path
        }).to eq(subject.each_script.to_a)
      end
    end

    describe "#sync_scripts!" do
      before do
        subject.cache_scripts!

        script_path = subject.find_script('cached/modified.rb')

        script_path.timestamp -= 10
        script_path.save

        script_path = subject.find_script('cached/cached.rb')
        script_path.destroy!

        subject.sync_scripts!
      end

      it "should update stale cached files" do
        script_path = subject.find_script('cached/modified.rb')

        expect(script_path.timestamp).to eq(File.mtime(script_path.path))
      end

      it "should cache new files" do
        expect(subject.find_script('cached/cached.rb')).not_to be_nil
      end
    end

    describe "#clean_scripts!" do
      before { subject.clean_scripts! }

      it "should clear the script_paths" do
        expect(subject.script_paths).to be_empty
      end
    end
  end
end
