require 'spec_helper'

describe Enum do

  before :all do
    class TestClass
      include Enum
      enum :status, [:foo, :bar]
      attr_accessor :status
    end
  end

  let(:test_class) { TestClass }
  let(:test_instance) { TestClass.new }

  context 'class' do
    let(:subject) { test_class }
    it { should respond_to(:enum) }

    it 'has a STATUS constant' do
      expect(test_class::STATUS).to be_present
    end

    it 'sets the constant with correct values' do
      expect(test_class::STATUS).to eq(foo: 0, bar: 1)
    end
  end

  context 'instance' do
    let(:subject) { test_instance }
    it { should respond_to(:foo?) }
    it { should respond_to(:bar?) }

    it 'queries status correctly' do
      test_instance.status = test_instance.class::STATUS[:foo]
      expect(test_instance).to be_foo
      expect(test_instance).to_not be_bar

      test_instance.status = test_instance.class::STATUS[:bar]
      expect(test_instance).to_not be_foo
      expect(test_instance).to be_bar
    end
  end

end
