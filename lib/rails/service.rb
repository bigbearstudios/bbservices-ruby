module BBServices
  module Rails
    class Service < BBServices::Service
      def resource
        @object
      end
    end
  end
end
