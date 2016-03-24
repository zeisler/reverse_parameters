require 'spec_helper'
require 'reverse_parameters'
require 'reverse_parameters/core_ext'

describe Method do
  describe '#reverse_parameters' do
    let(:subject) { method(:example) }

    def example
    end

    it { expect(subject.reverse_parameters).to be_an_instance_of(ReverseParameters::Base) }
  end
end

describe UnboundMethod do
  describe '#reverse_parameters' do
    class TestClass
      def test_method
      end
    end

    subject { TestClass.instance_method(:test_method) }

    it { expect(subject.reverse_parameters).to be_an_instance_of(ReverseParameters::Base) }
  end
end
