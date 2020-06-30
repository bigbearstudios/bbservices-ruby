module BBServices
  module Rails
    class New < Service

      protected
      
      def initialize_resource
        @object = service_class.new
      end

      def before_build() end

      def assign_attributes
        @object.assign_attributes(@params) if @params
      end

      def after_build() end

      def run_service
        internal_build
        @successful = true
      end

      def run_service!
        run_service
      end

      def internal_build
        before_build
        initialize_resource
        assign_attributes
        after_build
      end
    end
  end
end
