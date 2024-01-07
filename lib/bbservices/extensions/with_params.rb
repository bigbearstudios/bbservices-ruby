module BBServices
  module Extensions
    module WithParams

      # Default initalizer override which takes in the params. 
      # This will run through the run / run! methods which can take these params
      def initialize(**initialization_params)
        @params = initialization_params
      end

      protected

      # Returns true / false if the service has any params
      # @return [Boolean] true/false if the service has any params
      def has_params?
        @params.length > 0
      end

      def number_of_params
        @params.count
      end
    end
  end
end