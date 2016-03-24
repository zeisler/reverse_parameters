require 'spec_helper'
require 'reverse_parameters'

describe Method do
  describe '#reverse_parameters' do
    let(:subject) { method(:example) }

    def example
    end

    context "when not using refinement" do
      it { expect { subject.reverse_parameters }.to raise_error(NoMethodError) }
    end

    context "when using refinement" do
      using ReverseParameters
      it { expect(subject.reverse_parameters).to be_an_instance_of(ReverseParameters::Base) }
    end
  end
end

describe UnboundMethod do
  describe '#reverse_parameters' do
    class TestClass
      def test_method
      end
    end

    subject { TestClass.instance_method(:test_method) }

    context "when not using refinement" do
      it { expect { subject.reverse_parameters }.to raise_error(NoMethodError) }
    end

    context "when using refinement" do
      using ReverseParameters
      it { expect(subject.reverse_parameters).to be_an_instance_of(ReverseParameters::Base) }
    end
  end
end
