# frozen_string_literal: true

# The BBServices namespace.
module BBServices
  # Module to allow external classes (Namely controllers) to interact with underlying service objects
  module ServiceProvider
    def self.included(base)
      base.class_eval do

        # Creates a service with a given type and params, the service instance will not be ran.
        # Sets the @service instance on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @return [{BBServices::Service}] The service type instance
        def create_service(service_type, *args)
          @service = service_type.new(*args)
        end

        # Creates a service with a given type and params, the service instance will be ran using the run method.
        # Sets the @service instance on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @param [Block] block The block to call upon running of the service is complete
        # @return [{BBServices::Service}] The service type instance
        def run_service(service_type, *args, &block)
          create_service(service_type, *args).tap do |service|
            service.run(&block)
          end
        end

        # Creates a service with a given type and params, the service instance will be ran using the run! method.
        # Sets the @service instance on the object which includes this provider.
        # @param [Class] service_type The class which should be instanciated
        # @param [Hash] service_params The params which will be passed to the service
        # @param [Block] block The block to call upon running of the service is complete
        # @return [{BBServices::Service}] The service type instance
        def run_service!(service_type, *args, &block)
          create_service(service_type, *args).tap do |service|
            service.run!(&block)
          end
        end

        # 
        def chain_service(*args, &block)
          @service_chain = BBServices.chain(*args, &block)
        end

        # Returns the {BBService::Service} instance currently stored within @service. This is set
        # when a single service is ran. It will not be set when chain_service is used and service_chain
        # should be used instead.
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
