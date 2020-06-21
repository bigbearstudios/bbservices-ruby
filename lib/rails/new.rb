module BBServices
  module Rails

    #New
    #
    class New < Service

      protected

      def initialize_service
        @object = service_class.new
      end

      def before_build

      end

      def build
        if @params
          @object.assign_attributes(@params)
        end
      end

      def after_build

      end

      def run_service
        internal_build
        @successful = true
      end

      def run_service!
        run_service
      end

      def internal_build
        before_build
        build
        after_build
      end
    end
  end
end
