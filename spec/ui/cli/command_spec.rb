require 'spec_helper'
require 'ronin/ui/cli/command'

require 'ui/cli/classes/test_command'
require 'ui/cli/classes/namespace/test_command'

describe UI::CLI::Command do
  subject { UI::CLI::Commands::TestCommand }

  describe "command_name" do
    it "should omit the 'Ronin::UI::CLI::Commands' namespace" do
      subject.command_name.should_not include('ronin:ui:cli:commands')
    end

    it "should be derived from the Class name" do
      expect(subject.command_name).to eq('test_command')
    end

    context "with namespaces" do
      subject { UI::CLI::Commands::Namespace::TestCommand }

      it "should replace '::' with ':'" do
        subject.command_name.should == 'namespace:test_command'
      end
    end
  end

  describe "usage" do
    context "without an argument" do
      it "should return the set usage" do
        expect(subject.usage).to eq('[options] PATH FILE [..]')
      end
    end

    context "with an argument" do
      let(:expected) { 'FOO' }

      subject { Class.new(described_class) }
      before  { subject.usage expected }

      it "should set the usage" do
        expect(subject.usage).to eq(expected)
      end
    end

    context "default" do
      subject { Class.new(described_class).usage }

      it { should == '[options]' }
    end

    context "inherited" do
      let(:superclass) { UI::CLI::Commands::TestCommand }

      subject { Class.new(superclass).usage }

      it "should default to the usage of the superclass" do
        expect(subject).to eq(superclass.usage)
      end
    end
  end

  describe "summary" do
    context "without an argument" do
      it "should return the set summary" do
        expect(subject.summary).to eq('Tests the default task')
      end
    end

    context "with an argument" do
      let(:expected) { 'Performs foo' }

      subject { Class.new(described_class) }
      before  { subject.summary expected }

      it "should set the usage" do
        expect(subject.summary).to eq(expected)
      end
    end

    context "default" do
      subject { Class.new(described_class).summary }

      it { should == nil }
    end

    context "inherited" do
      let(:superclass) { UI::CLI::Commands::TestCommand }

      subject { Class.new(superclass).summary }

      it "should default to the summary of the superclass" do
        expect(subject).to eq(superclass.summary)
      end
    end
  end

  describe "examples" do
    context "without an argument" do
      it "should return the set summary" do
        # subject.example.should == 'Tests the default task'
      end
    end

    context "with an argument" do
      let(:expected) do
        ['test_command --foo PATH', 'test_command --foo PATH FILE ...']
      end

      subject { Class.new(described_class) }
      before  { subject.examples expected }

      it "should set the usage" do
        expect(subject.examples).to eq(expected)
      end
    end

    context "default" do
      subject { Class.new(described_class).examples }

      it { should == [] }
    end

    context "inherited" do
      let(:superclass) { UI::CLI::Commands::TestCommand }

      subject { Class.new(superclass).examples }

      it "should default to the examples of the superclass" do
        expect(subject).to eq(superclass.examples)
      end
    end
  end

  describe "options" do
    subject { Class.new(described_class).options }

    context "inherited" do
      it "should be {} by default" do
        expect(subject).to eq({})
      end
    end

    context described_class do
      subject { described_class.options }

      it "should have a :verbose option" do
        expect(subject).to have_key(:verbose)
      end

      it "should have a :quiet option" do
        expect(subject).to have_key(:quiet)
      end

      it "should have a :silent option" do
        expect(subject).to have_key(:silent)
      end
    end
  end

  describe "option" do
    let(:name) { :foo }

    it "should define an option" do
      expect(subject.options[name]).to be_kind_of(Hash)
    end

    it "should define a parameter" do
      expect(subject).to have_param(name)
    end
  end

  describe "each_option" do
    let(:expected) { [:verbose, :quiet, :silent, :foo] }

    it "should iterate over each option" do
      names = []

      subject.each_option do |name,options|
        names << name
      end

      expect(names).to match_array(expected)
    end
  end

  describe "options?" do
    it "should test if there are any defined options" do
      expect(subject.options?).to be(true)
    end
  end

  describe "arguments" do
    context "inherited" do
      subject { Class.new(described_class).arguments }

      it { should == [] }
    end
  end

  describe "argument" do
    let(:name) { :foo }

    subject { Class.new(described_class) }
    before  { subject.argument name      }

    it "should add to arguments" do
      expect(subject.arguments).to include(name)
    end

    it "should define a parameter" do
      expect(subject).to have_param(name)
    end
  end

  describe "each_argument" do
    let(:expected) { [:path, :files] }

    it "should iterate over each option" do
      names = []

      subject.each_argument { |name| names << name }

      expect(names).to match_array(expected)
    end
  end

  describe "arguments?" do
    it "should test if there are any defined arguments" do
      expect(subject.arguments?).to be(true)
    end
  end

  describe "#run" do
    it "should allow running the command with options" do
      command = subject.new
      value   = 'bar'

      command.run(:foo => value)

      expect(command.foo).to eq(value)
    end
  end

  describe "#start" do
    subject { UI::CLI::Commands::TestCommand.new }

    it "should parse options" do
      value = 'baz'
      subject.start(['--foo', value])

      expect(subject.foo).to eq(value)
    end

    it "should parse additional arguments" do
      path = 'to/file.txt'

      subject.start([path])

      expect(subject.path).to eq(path)
    end

    it "should parse additional arguments into an Array/Set argument" do
      value = 'bax'
      path  = 'to/file.txt'
      files = ['one.txt', 'two.txt']

      subject.start(['--foo', value, path, *files])

      expect(subject.foo).to eq(value)
      expect(subject.path).to eq(path)
      expect(subject.files).to eq(files)
    end
  end
end
