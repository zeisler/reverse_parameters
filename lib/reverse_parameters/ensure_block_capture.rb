module ReverseParameters
  class EnsureBlockCapture < Base
    # Ensure a block capture is returned in the method signature.
    #
    # def my_method(a, key:);end
    #
    # ReverseParameters::EnsureBlockCapture(method(:my_method)).parameters.to_s
    #   #=> "a, key:, &block"
    #
    # @return [ReverseParameters::Parameters]
    def parameters
      Parameters.new(ensure_block(params))
    end

    # Ensure a block is being passed even if the method signature does not define it.
    #
    # def my_method(a, key:);end
    #
    # ReverseParameters::EnsureBlockCapture(method(:my_method)).parameters.to_s
    #   #=> "a, key: key, &block"
    #
    # @return [ReverseParameters::Arguments]
    def arguments
      Arguments.new(ensure_block(params))
    end

    private

    def ensure_block(array)
      array.concat([array.pop, [:block, :block]].uniq).reject(&:nil?)
    end
  end
end
