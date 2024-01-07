module BBServices
  module Extensions

    # WIP
    # This is not currently included in the BBServices requires, not sure if this will be 
    # added in this current version (4.0.0)
    module WithParamsTypeChecked < BBServices::Extensions::WithParams
      class BBServiceHashTypeError < StandardError
        def message
          'BBServices::Extensions::WithParams - param on run / run! or new needs to be a Hash (or subclass of)'
        end
      end   

      # Default initalizer override which takes in the params. 
      # This will run through the run / run! methods which can take these params
      def initialize(**params)
        throw BBServices::Extensions::WithParamsBBServiceHashTypeError unless params.is_a?(Hash)

        @params = params
      end

      # Returns true / false if the service has any params
      # @return [Boolean] true/false if the service has any params
      def params?
        !!(@params && @params.length)
      end
    end
  end
end