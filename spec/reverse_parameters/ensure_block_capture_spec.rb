require 'spec_helper'
require 'reverse_parameters'
require 'reverse_parameters/ensure_block_capture'

RSpec.describe ReverseParameters::EnsureBlockCapture do

  let(:subject) { described_class.new(method(:example)) }

  describe "#arguments" do

    def example(req_param, key_param: nil)
      req_param + key_param + yield
    end

    it do
      r = eval <<-RUBY, binding, __FILE__, __LINE__+1
          req_param = 1
          key_param = 2
          block = Proc.new { 3 }
          example(#{subject.arguments})
      RUBY
      expect(r).to eq 6
    end

    it { expect(subject.arguments.to_s).to eq('req_param, key_param: key_param, &block') }

    describe '#to_a' do
      it { expect(subject.arguments.to_a).to eq(['req_param', 'key_param: key_param', '&block']) }
    end
  end

  describe "#parmeters" do

    let(:subject) { described_class.new(method(:example)).parameters }
    let(:recreation_proc){
      instance_eval <<-RUBY, __FILE__, __LINE__
          def recreation(#{subject})
          end
      RUBY
      method(:recreation)
    }

    def example(req_param, *rest_param)
    end

    it { expect(recreation_proc.parameters).to eq method(:example).parameters << [:block, :block] }
    it { expect(subject.to_s).to eq("req_param, *rest_param, &block") }

    context "no_args" do
      def example
      end

      it { expect(recreation_proc.parameters).to eq method(:example).parameters << [:block, :block] }
      it { expect(subject.to_s).to eq("&block") }
    end
  end
end
