class BBServices::Extensions::WithParams

  class BBServiceHashTypeError < StandardError
    def message
      'Params need to be a Hash'
    end
  end

  # Returns true / false if the service has any params
  # @return [Boolean] true/false if the service has any params
  def params?
    !!(@params && @params.length)
  end
end