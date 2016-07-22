require "reverse_parameters/version"
require "reverse_parameters/core_ext/refinements"

module ReverseParameters
  # @param [Proc, Array, UnboundMethod, Method] input
  def self.new(*args)
    Base.new(*args)
  end

  class Base

    # @param [Proc, Array] input
    def initialize(input)
      if input.respond_to?(:to_proc)
        @params = input.to_proc.parameters
      elsif input.respond_to?(:to_ary)
        @params = input.to_ary
      elsif input.is_a? UnboundMethod
        @params = input.parameters
      else
        raise ArgumentError.new("Input must be an Array of parameters or a Proc object.")
      end
    end

    # Parameters are the names listed in the method definition, also know as the method signature.
    #
    # def my_method(a, key:);end
    #
    # ReverseParameters.new(method(:my_method)).arguments.to_s
    #   #=> "a, key:"
    #
    # # @return [ReverseParameters::Parameters]
    def parameters
      Parameters.new(params)
    end

    # Arguments are the real values passed to (and received by) the method.
    #
    # def my_method(a, key:, &block);end
    # ReverseParameters.new(method(:my_method)).arguments.to_s
    #   #=> "a, key: key, &block"
    #
    # @return [ReverseParameters::Arguments]
    def arguments
      Arguments.new(params)
    end

    private
    attr_reader :params
  end

  class BaseCollection
    include Enumerable

    def initialize(collection, **options)
      @collection = collection.map { |state, name| item_class.new(state: state, name: name, **options) }
    end

    def each(&block)
      @collection.send(:each, &block)
    end

    def to_s
      to_a.join(', ')
    end

    def to_a
      map(&:to_s)
    end

    class Item
      def initialize(name:, state:, **options)
        @name  = name
        @state = state
        post_initialize(options)
      end

      def post_initialize(*)
      end

      attr_reader :name, :state
    end
  end

  class Arguments < BaseCollection

    class Arg < BaseCollection::Item
      def to_s
        case state
        when :key, :keyreq
          "#{name}: #{name}"
        when :keyrest
          "**#{name}"
        when :rest
          "*#{name}"
        when :block
          block(name)
        else
          name
        end.to_s
      end

      private

      def post_initialize(blocks_as_values:)
        @blocks_as_values = blocks_as_values
      end

      def block(name)
        if @blocks_as_values
          name
        else
          "&#{name}"
        end
      end
    end

    def item_class
      Arguments::Arg
    end
  end

  class Parameters < BaseCollection;
    class Param < BaseCollection::Item
      def to_s
        case state
        when :req
          name
        when :rest
          "*#{name}"
        when :keyrest
          "**#{name}"
        when :opt
          "#{name}=nil"
        when :keyreq
          "#{name}:"
        when :key
          "#{name}: nil"
        when :block
          "&#{name}"
        end.to_s
      end
    end

    def item_class
      Parameters::Param
    end
  end
end
