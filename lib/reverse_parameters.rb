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

    protected
    attr_reader :params
  end

  class BaseCollection
    include Enumerable

    def initialize(collection, **options)
      @collection = collection.map { |state, name| item_class.new(state: state, name: name, **options) }
      @pre_collection = collection
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

    # @return [ArgumentsWithValues] defines example values to arguments in line.
    def with_values
      ArgumentsWithValues.new(@pre_collection)
    end

    class Arg < BaseCollection::Item
      def to_s
        send(state.to_sym).to_s
      rescue NoMethodError
        name.to_s
      end

      protected

      def key
        "#{name}: #{name}"
      end

      alias_method :keyreq, :key

      def keyrest
        "**#{name}"
      end

      def rest
        "*#{name}"
      end

      def block
        "&#{name}"
      end
    end

    private

    def item_class
      Arguments::Arg
    end
  end

  class ArgumentsWithValues < Arguments
    class Item < BaseCollection::Item
      def to_s
        send(state.to_sym).to_s
      rescue NoMethodError
        "#{name}='#{name}'"
      end

      def key
        "#{name}: '#{name}'"
      end

      alias_method :keyreq, :key

      def keyrest
        "**#{name}={}"
      end

      def rest
        "*#{name}=[]"
      end

      def block
        "&#{name}=Proc.new{}"
      end
    end

    def item_class
      ArgumentsWithValues::Item
    end
  end

  class Parameters < BaseCollection;
    class Param < BaseCollection::Item
      def to_s
        send(state.to_sym).to_s
      end

      protected

      def req
        name
      end

      def rest
        "*#{name}"
      end

      def keyrest
        "**#{name}"
      end

      def opt
        "#{name}=nil"
      end

      def keyreq
        "#{name}:"
      end

      def key
        "#{name}: nil"
      end

      def block
        "&#{name}"
      end
    end

    def item_class
      Parameters::Param
    end
  end
end
