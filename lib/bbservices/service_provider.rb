# frozen_string_literal: true

# The BBServices namespace.
module BBServices
  
  # Module to allow external classes (Namely controllers) to interact with underlying service objects
  module ServiceProvider
    def self.included(base)
      base.class_eval do

        # Creates a service with a given type and params, the service instance will not be ran. Sets the @service instance
        # on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @return [{BBServices::Service}] The service type instance
        def create_service(service_type, service_params = {})
          @service = service_type.new.tap do |new_service|
            new_service.set_params(service_params)
          end
        end

        # Creates a service with a given type and params, the service instance will be ran using the run method. Sets the @service instance
        # on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @param [Block] block The block to call upon running of the service is complete
        # @return [{BBServices::Service}] The service type instance
        def run_service(service_type, service_params = {}, &block)
          create_service(service_type, service_params).tap do |service|
            service.service_class = service_type
            service.run(&block)
          end
        end

        # Creates a service with a given type and params, the service instance will be ran using the run! method. Sets the @service instance
        # on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @param [Block] block The block to call upon running of the service is complete
        # @return [{BBServices::Service}] The service type instance
        def run_service!(service_type, service_params = {}, &block)
          create_service(service_type, service_params).tap do |service|
            service.service_class = service_type
            service.run!(&block)
          end
        end

        def chain_services(params = {}, &block) 
          @service_chain = BBServices.chain(params, &block)
        end

        # Returns the {BBService::Service} instance currently stored within @service
        # @return [{BBService::Service}] The current service
        def service
          @service
        end

        # Returns the {BBServices::ServiceChain} instance currently stored within @service_chain
        # @return [{BBServices::ServiceChain}] The current service
        def service_chain 
          @service_chain
        end
      end
    end
  end
end
