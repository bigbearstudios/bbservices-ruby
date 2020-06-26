module BBServices
  module ServiceProvider
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do

        ##
        # Creates a brand new service of a given type
        def service(service_type, service_params = {}, associated_params = {}, &block)
          @service = service_type.new.tap do |service|
            service.params = service_params
            service.associated_params = associated_params
          end
        end

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
      end
    end

    module ClassMethods

    end
  end
end
