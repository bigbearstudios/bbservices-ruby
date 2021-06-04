# frozen_string_literal: true

# The BBServices namespace.
module BBServices
  # Container for chained services.
  class ServiceChain

    attr_reader :services

    # Initializes the ServiceChain
    def initialize
      @services = []
      @successful = true
    end

    def chain(params = {})
      tap do |_service_chain|
        if @successful
          service = yield(params, self, previous_service)
          process_service(service)
        end
      end
    end

    def previous_service
      return nil unless @services.length

      @services.last
    end

    # Returns true/false on if the chain did succeed.
    # @return [Boolean] true/false on if the chain did succeed.
    def succeeded?
      successful?
    end

    # Returns true/false on if the chain was successful.
    # @return [Boolean] true/false on if the chain was successful.
    def successful?
      @successful
    end

    # Returns true/false on if the chain was unsuccessful. This will always be the inverse of successful?
    # @return [Boolean] true/false on if the chain failed.
    def failed?
      !succeeded?
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

    # Returns true / false if the chain threw an error
    # @return [Boolean] true/false on if an error has occurred
    def error?
      previous_service ? previous_service.error? : false
    end

    def error
      previous_service ? previous_service.error : nil
    end

    private

    def process_service(service)
      if service.is_a?(BBServices::Service)
        @services << service
        @successful = service.successful?
      else
        @successful = !!service
      end
    end
  end
end
