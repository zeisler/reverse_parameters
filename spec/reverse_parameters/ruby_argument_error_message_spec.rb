require 'spec_helper'
require 'reverse_parameters/ruby_argument_error_message'
require "rubygems/version"

RSpec.describe ReverseParameters::RubyArgumentErrorMessage do
  let(:example_methods) {
    Proc.new do |example1:, example2:|
      eval <<-RUBY, binding, __FILE__, __LINE__+1
          def example1(#{example1})
          end

          def example2(#{example2})
          end
      RUBY
    end
  }

  subject { described_class.new(method(:example1)).message_if_called_with(method(:example2)) }

  describe "#message_if_called_with" do
    it "missing keyword" do
      example_methods.call(example1: "a:,b:", example2: "a:")
      expect(subject).to eq("missing keyword: b")
    end

    it "missing keywords" do
      example_methods.call(example1: "a:,b:,c:", example2: "a:")
      expect(subject).to eq("missing keywords: b, c")
    end

    it "missing args" do
      example_methods.call(example1: "a", example2: "a,c,d")
      msg = if Gem::Version.new(RUBY_VERSION) > Gem::Version.new("2.3")
              "wrong number of arguments (given 3, expected 1)"
            else
              "wrong number of arguments (3 for 1)"
            end
      expect(subject).to eq(msg)
    end

    it "values given for double splat" do
      example_methods.call(example1: "a", example2: "**a")
      expect(subject).to eq(false)
    end

    it "values given for splat" do
      example_methods.call(example1: "*a", example2: "a,b")
      expect(subject).to eq(false)
    end

    it "splat empty array in method that takes no args" do
      example_methods.call(example1: "", example2: "*a")
      expect(subject).to eq(false)
    end

    it "blocks" do
      example_methods.call(example1: "&blk", example2: "&block")
      expect(subject).to eq(false)
    end
  end
end
