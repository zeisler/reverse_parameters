require 'spec_helper'
require 'reverse_parameters'

describe ReverseParameters do
  describe '#parameters' do

    let(:subject) { described_class.new(method_proc).parameters.to_s }
    let(:method_proc) { method(:example) }
    let(:recreation_proc){
        instance_eval <<-RUBY, __FILE__, __LINE__
          def recreation(#{subject})
          end
        RUBY
        method(:recreation)
    }

    context 'keyreq' do

      def example(named_param:)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('named_param:') }
    end

    context 'key' do

      def example(named_param: [])
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('named_param: nil') }
    end

    context 'req' do

      def example(req_param)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('req_param') }
    end

    context 'rest' do

      def example(*rest_param)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('*rest_param') }
    end

    context 'opt' do

      def example(opt_param=nil)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('opt_param=nil') }
    end

    context 'req, rest' do

      def example(req_param, *rest_param)
      end

      it do
        expect(recreation_proc.parameters).to eq method_proc.parameters
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('req_param, *rest_param') }
    end

    context 'req, opt' do

      def example(req_param, opt_param = {})
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('req_param, opt_param=nil') }
    end

    context 'key, keyreq' do

      def example(named_param: 1, named_param_req:)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('named_param_req:, named_param: nil') }
    end

    context 'rep, key' do

      def example(req_param, key_param: 2)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('req_param, key_param: nil') }

      describe '#to_a' do
        it { expect(described_class.new(method_proc).parameters.to_a).to eq(['req_param', 'key_param: nil']) }
      end
    end

    context 'keyrest' do

      def example(**keyrest)
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq('**keyrest') }
    end

    context 'block' do

      def example(&blk)
        blk.call
      end

      it { expect(recreation_proc.parameters).to eq method_proc.parameters }
      it { expect(subject).to eq("&blk") }
    end
  end

  describe '#arguments' do

    let(:subject) { described_class.new(method_proc.parameters).arguments.to_s }
    let(:method_proc) { method(:example) }

    context 'keyreq' do

      def example(named_param:)
        named_param
      end

      it do
        named_param = "hello"
        r = eval <<-RUBY
          example(#{subject})
        RUBY
        expect(r).to eq named_param
      end

      it { expect(subject).to eq('named_param: named_param') }
    end

    context 'key' do

      def example(named_param: nil)
        named_param
      end

      it do
        named_param = "hello"
        r = eval <<-RUBY
          example(#{subject})
        RUBY
        expect(r).to eq named_param
      end

      it { expect(subject).to eq('named_param: named_param') }
    end

    context 'req' do

      def example(req_param)
        req_param
      end

      it do
        req_param = "hello"
        r = eval <<-RUBY
          example(#{subject})
        RUBY
        expect(r).to eq req_param
      end

      it { expect(subject).to eq('req_param') }
    end

    context 'rest' do

      def example(*rest_param)
        rest_param
      end

      it do
        rest_param = "hello"
        r = eval <<-RUBY
          example(#{subject})
        RUBY
        expect(r).to eq [rest_param]
      end

      it { expect(subject).to eq('rest_param') }
    end

    context 'opt' do

      def example(opt_param=nil)
        opt_param
      end

      it do
        opt_param = "hello"
        r = eval <<-RUBY
          example(#{subject})
        RUBY
        expect(r).to eq opt_param
      end

      it { expect(subject).to eq('opt_param') }
    end

    context 'keyrest' do

      def example(**keyrest)
        keyrest
      end

      it do
        keyrest = {key1: :value1, key2: :value1}
        r = eval <<-RUBY
          example(#{subject})
        RUBY
        expect(r).to eq keyrest
      end

      it { expect(subject).to eq('keyrest') }
    end

    context 'block' do

      def example(&blk)
        blk.call
      end

      it do
        r = eval <<-RUBY
          blk = -> { 10 }
          example(#{subject})
        RUBY
        expect(r).to eq 10
      end

      it { expect(subject).to eq("&blk") }

      it 'blocks as values' do
        expect(described_class.new(method_proc, blocks_as_values: true).arguments.to_s).to eq("blk")
      end
    end

    context 'req, rest' do

      def example(req_param, *rest_param)
        [*req_param].concat rest_param
      end

      it do
        r = eval <<-RUBY
          req_param = 3
          rest_param = 1
          example(#{subject})
        RUBY
        expect(r).to eq [3, 1]
      end

      it { expect(subject).to eq('req_param, rest_param') }
    end

    context 'req, opt' do

      def example(req_param, opt_param=nil)
        req_param + opt_param
      end

      it do
        r = eval <<-RUBY
          req_param = 2
          opt_param = 3
          example(#{subject})
        RUBY
        expect(r).to eq 5
      end

      it { expect(subject).to eq('req_param, opt_param') }
    end

    context 'key, keyreq' do

      def example(named_param_req: nil, named_param:)
        named_param_req + named_param
      end

      it do
        r = eval <<-RUBY
          named_param_req = 1
          named_param = 3
          example(#{subject})
        RUBY
        expect(r).to eq 4
      end

      it { expect(subject).to eq('named_param: named_param, named_param_req: named_param_req') }
    end

    context 'rep, key' do

      def example(req_param, key_param: nil)
        req_param + key_param
      end

      it do
        r = eval <<-RUBY
          req_param = 1
          key_param = 2
          example(#{subject})
        RUBY
        expect(r).to eq 3
      end

      it { expect(subject).to eq('req_param, key_param: key_param') }

      describe '#to_a' do
        it { expect(described_class.new(method_proc).arguments.to_a).to eq(['req_param', 'key_param: key_param']) }
      end
    end

    context 'ArgumentError' do

      it 'raises an error if input is not a Proc or an Array' do
        expect { described_class.new(1) }.to raise_error(ArgumentError, 'Input must be an Array of parameters or a Proc object.')
      end
    end
  end
end
