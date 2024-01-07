# frozen_string_literal: true

# The BBServices namespace.
module BBServices
  # Container for chained services.
  class ServiceChain
    
    attr_reader :services

    # Initializes the ServiceChain
    # @services a list of the services in the chain
    def initialize
      @successful = nil
      @services = []
      @last_service_ran = nil
    end

    # Creates a new chain in the service
    def chain(*args, &block)
      tap do |_service_chain|
        if continue_chain?
          service = yield(*args, self, last_service)

          # If a service is returned we store the service
          # and take the successful? variable into our own
          if BBServices.is_a_service?(service)
            @successful = service.successful?
            @services << service
          else
            @successful = true
            # Otherwise we have had something else back from the service
          end
        end
      end
    end

    # Returns the last service which was ran. This will return the last
    # service, if the previous chain returned a non-service instance
    def last_service
      @services.last
    end

    # Returns true/false on if the chain did succeed.
    # @return [Boolean] true/false on if the chain did succeed.
    def succeeded?
      successful?
    end

    # Returns true/false on if the service was successful.
    # @return [Boolean] true/false on if the service was successful.
    def successful?
      (@successful == nil ? false : @successful) 
    end

    # Returns true/false on if the service was unsuccessful. This will always be the inverse of successful?
    # @return [Boolean] true/false on if the service failed.
    def failed?
      (@successful == nil ? false : !@successful) 
    end

    # Calls the given block if the chain was successful
    def success
      yield(self) if succeeded?
    end

    # Calls the given block if the chain failed
    def failure
      yield(self) if failed?
    end

    # Calls success on success?, failure on !success?
    # @param [Proc] success The proc to be called upon a successful chain
    # @param [Proc] failure
    # @return [Boolean] true/false if the chain has any params
    def on(success: proc {}, failure: proc {})
      if successful?
        success.call
      else
        failure.call
      end
    end

    # Returns a true / false value if an error has been thrown, this
    # will be passed to the last_service if one is avalible, otherwise
    # false will be returned
    # @return [Boolean] true/false on if an error has occurred
    def error?
      last_service ? last_service.error? : false
    end

    # Returns all of the errors from the last_service, if no last_service
    # is avalible then an empty array will be returned
    def errors
      last_service ? last_service.errors : []
    end

    private

    # Should the chain continue?
    # If we don't have a last service, return true
    # If we have a last service check the successful? method
    def continue_chain?
      last_service == nil ? true : last_service.successful?
    end
  end
end
