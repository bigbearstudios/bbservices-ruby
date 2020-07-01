module BBServices
  module Rails
    module ServiceProvider
      def self.included(base)
        base.extend ClassMethods
        base.class_eval do

          register_controller_helper :service_resource

          ##
          # Creates and runs a Rails::New service. This is essentially a helper method from stopping you having
          # to create multiple Rails::New services which essentially just have a different model attached to them
          def run_new_service(type, service_params = nil, associated_params = nil, &block)
            service(BBServices::Rails::New, service_params, associated_params).tap do |service|
              service.service_class = type
              service.run(&block)
            end
          end

          ##
          # Creates and runs a Rails::New service. This is essentially a helper method from stopping you having
          # to create multiple Rails::New services which essentially just have a different model attached to them
          def run_new_service!(type, service_params = nil, associated_params = nil, &block)
            service(BBServices::Rails::New, service_params, associated_params).tap do |service|
              service.service_class = type
              service.run!(&block)
            end
          end

          ##
          # Creates and runs a Rails::Create service. This is essentially a helper method from stopping you having
          # to create multiple Rails::Create services which essentially just have a different model attached to them
          def run_create_service(type, service_params = nil, associated_params = nil, &block)
            service(BBServices::Rails::Create, service_params, associated_params).tap do |service|
              service.service_class = type
              service.run(&block)
            end
          end

          ##
          # Creates and runs a Rails::Create service. This is essentially a helper method from stopping you having
          # to create multiple Rails::Create services which essentially just have a different model attached to them
          def run_create_service!(type, service_params = nil, associated_params = nil, &block)
            service(BBServices::Rails::Create, service_params, associated_params).tap do |service|
              service.service_class = type
              service.run!(&block)
            end
          end

          ##
          # Creates an underlying service and then runs the service
          def run_service(service_type, service_params = {}, associated_params = {}, &block)
            service(service_type, service_params, associated_params).tap do |service|
              service.service_class = service_type
              service.run(&block)
            end
          end

          def run_service!(service_type, service_params = {}, associated_params = {}, &block)
            service(service_type, service_params, associated_params).tap do |service|
              service.service_class = service_type
              service.run!(&block)
            end
          end

          ##
          # Creates a brand new service of a given type
          def service(service_type, service_params = nil, associated_params = nil)
            @service = service_type.new.tap do |service|
              service.params = service_params
              service.associated_params = associated_params
            end
          end

          def service_resource
            @service.resource if @service 
          end
        end
      end

      module ClassMethods
        def register_controller_helper(*methods)
          helper_method(methods) if respond_to?(:helper_method)
        end
      end
    end
  end
end
