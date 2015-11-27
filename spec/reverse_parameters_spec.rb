require 'spec_helper'
require 'reverse_parameters'

describe ReverseParameters do
  describe '#parameters' do

    let(:subject) { described_class.new(method_proc).parameters.to_s }
    let(:method_proc) { method(:example) }

    context 'keyreq' do

      def example(named_param:)
      end

      it { expect(subject).to eq('named_param:') }
    end

    context 'key' do

      def example(named_param: [])
      end

      it { expect(subject).to eq('named_param: nil') }
    end

    context 'req' do

      def example(req_param)
      end

      it { expect(subject).to eq('req_param') }
    end

    context 'rest' do

      def example(*rest_param)
      end

      it { expect(subject).to eq('*rest_param') }
    end

    context 'opt' do

      def example(opt_param=nil)
      end

      it { expect(subject).to eq('opt_param=nil') }
    end

    context 'req, rest' do

      def example(req_param, *rest_param)
      end

      it { expect(subject).to eq('req_param, *rest_param') }
    end

    context 'req, opt' do

      def example(req_param, opt_param = {})
      end

      it { expect(subject).to eq('req_param, opt_param=nil') }
    end

    context 'key, keyreq' do

      def example(named_param: 1, named_param_req:)
      end

      it { expect(subject).to eq('named_param_req:, named_param: nil') }
    end

    context 'rep, key' do

      def example(req_param, key_param: 2)
      end

      it { expect(subject).to eq('req_param, key_param: nil') }

      describe '#to_a' do
        it { expect(described_class.new(method_proc).parameters.to_a).to eq(['req_param', 'key_param: nil']) }
      end
    end

    context 'keyrest' do

      def example(**keyrest)
      end

      it { expect(subject).to eq('**keyrest') }
    end
  end

  describe '#arguments' do

    let(:subject) { described_class.new(method_proc.parameters).arguments.to_s }
    let(:method_proc) { method(:example) }

    context 'keyreq' do

      def example(named_param:)
      end

      it { expect(subject).to eq('named_param: named_param') }
    end

    context 'key' do

      def example(named_param: nil)
      end

      it { expect(subject).to eq('named_param: named_param') }
    end

    context 'req' do

      def example(req_param)
      end

      it { expect(subject).to eq('req_param') }
    end

    context 'rest' do

      def example(*rest_param)
      end

      it { expect(subject).to eq('rest_param') }
    end

    context 'opt' do

      def example(opt_param=nil)
      end

      it { expect(subject).to eq('opt_param') }
    end

    context 'keyrest' do

      def example(**keyrest)
      end

      it { expect(subject).to eq('keyrest') }
    end

    context 'req, rest' do

      def example(req_param, *rest_param)
      end

      it { expect(subject).to eq('req_param, rest_param') }
    end

    context 'req, opt' do

      def example(req_param, opt_param=nil)
      end

      it { expect(subject).to eq('req_param, opt_param') }
    end

    context 'key, keyreq' do

      def example(named_param_req: nil, named_param:)
      end

      it { expect(subject).to eq('named_param: named_param, named_param_req: named_param_req') }
    end

    context 'rep, key' do

      def example(req_param, key_param: nil)
      end

      it { expect(subject).to eq('req_param, key_param: key_param') }

      describe '#to_a' do
        it { expect(described_class.new(method_proc).arguments.to_a).to eq(['req_param', 'key_param: key_param']) }
      end
    end

    context 'ArgumentError' do

      it 'raises an error if input is not a Proc or an Array' do
        expect{ described_class.new(1) }.to raise_error(ArgumentError, 'Input must be an Array of parameters or a Proc object.')
      end
    end
  end
end
