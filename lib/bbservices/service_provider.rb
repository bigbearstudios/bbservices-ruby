# frozen_string_literal: true

module BBServices

  # Module to allow external classes to interact with underlying service objects
  # in a structured way. This will allow the setting of services upon the calling
  # of given methods. Services will also be bound to the provider.
  module ServiceProvider
    def self.included(base)
      base.class_eval do

        # Creates a service with a given type and params, the service instance will not be ran.
        # Sets the @service instance on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @return [{BBServices::Service}] The service type instance
        def create_service(service_type, *args, **kwargs)
          @service = service_type.new(*args, **kwargs)
        end

        # Creates a service with a given type and params, the service instance will be ran using the run method.
        # Sets the @service instance on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @param [Block] block The block to call upon running of the service is complete
        # @return [{BBServices::Service}] The service type instance
        def run_service(service_type, *args, **kwargs, &block)
          create_service(service_type, *args, **kwargs).tap do |service|
            service.run(&block)
          end
        end

        # Creates a service with a given type and params, the service instance will be ran using the run! method.
        # Sets the @service instance on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @param [Block] block The block to call upon running of the service is complete
        # @return [{BBServices::Service}] The service type instance
        def run_service!(service_type, *args, **kwargs, &block)
          create_service(service_type, *args, **kwargs).tap do |service|
            service.run!(&block)
          end
        end

        # Returns the {BBService::Service} instance currently stored within @service. This is set
        # when a single service is ran. It will not be set when chain_service is used and service_chain
        # should be used instead.
        # @return [{BBService::Service}] The current service
        def service
          @service
        end
      end
    end
  end
end
