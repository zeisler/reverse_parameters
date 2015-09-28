require "reverse_parameters/version"

class ReverseParameters

  def initialize(input)
    if input.respond_to?(:to_proc)
      @params = input.to_proc.parameters
    elsif input.respond_to?(:to_ary)
      @params = input.to_ary
    else
      raise ArgumentError.new("Input must be an Array of parameters or a Proc object.")
    end
  end

  # Method parameters are the names listed in the function definition.
  def parameters
    Parameters.new(params)
  end

  # Method arguments are the real values passed to (and received by) the function.
  def arguments
    Arguments.new(params)
  end

  private
  attr_reader :params

  class BaseCollection
    include Enumerable

    def initialize(collection)
      @collection = collection.map{|state, name| item_class.new(state: state, name: name)}
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
      def initialize(name:, state:)
        @name  = name
        @state = state
      end
      attr_reader :name, :state
    end
  end

  class Arguments < BaseCollection;
    class Arg < BaseCollection::Item
      def to_s
        case state
          when :key, :keyreq
            "#{name}: #{name}"
          else
            name
        end.to_s
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
          when :opt
            "#{name}=nil"
          when :keyreq
            "#{name}:"
          when :key
            "#{name}: nil"
        end.to_s
      end
    end

    def item_class
      Parameters::Param
    end
  end
end
