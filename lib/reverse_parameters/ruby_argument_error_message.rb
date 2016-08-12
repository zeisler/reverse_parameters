require "reverse_parameters"

module ReverseParameters
  class RubyArgumentErrorMessage

    # @param [ReverseParameters::Base] input
    def initialize(input, debug: false)
      @input = ReverseParameters.new(input)
      @debug = debug
    end

    # @param [ReverseParameters::Base] other
    # @return [false] when the two methods have compatible signatures
    # @return [String] when the two methods do not have compatible signatures it returns the ruby error message.
    def message_if_called_with(other)
      arguments = ReverseParameters.new(other).arguments
      eval(<<-RUBY.tap(&method(:debug)))
        def input_method(#{@input.parameters})
        end
        input_method(#{arguments.with_values})
      RUBY
      false
    rescue ArgumentError => e
      e.message
    end

    private

    attr_reader :input

    def debug(methods)
      @debug ? puts(methods) : nil
    end
  end
end
