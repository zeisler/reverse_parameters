module ReverseParameters
  refine Method do
    # @return [ReverseParameters]
    def reverse_parameters
      ReverseParameters.new(parameters)
    end
  end

  refine UnboundMethod do
    # @return [ReverseParameters]
    def reverse_parameters
      ReverseParameters.new(parameters)
    end
  end
end
