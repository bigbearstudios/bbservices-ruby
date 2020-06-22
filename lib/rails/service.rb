module BBServices
  module Rails

    ##
    # This class acts as the base class for all Rails / ActiveRecord variants
    # of the Service Class
    class Service < BBServices::Service
      def resource
        @object
      end
    end
  end
end
