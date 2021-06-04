# frozen_string_literal: true

require_relative 'service_chain'

# The BBServices namespace.
module BBServices
  # Error thrown when a Hash type isn't given
  class ServiceHashTypeError < StandardError
    def message
      'Params need to be a Hash'
    end
  end

  # The lightweight service object provided by BBServices.
  class Service
    attr_reader :params, :object, :error

    class << self

      # Creates the service instances and calls run upon said instance
      # @param [Hash] params The params which are passed to the service
      # @param [Block] block The block which will be called upon the service finishing running
      # @return [BBServices.Service] returns the service instance
      def run(params = {}, &block)
        new(params).tap do |service|
          service.run(&block)
        end
      end

      # Creates the service instances and calls run! upon said instance
      # @param [Hash] params The params which are passed to the service
      # @param [Block] block The block which will be called upon the service finishing running
      # @return [BBServices.Service] returns the service instance
      def run!(params = {}, &block)
        new(params).tap do |service|
          service.run!(&block)
        end
      end

      # An alias to {BBServices::Service}'s run method
      alias call run

      # An alias to {BBServices::Service}'s run! method
      alias call! run!

      # Sets the service class on the Class. Please note this is an internal method.
      # @param [Class] klass The class which will be set as the service_class
      # @return [BBServices.Service] returns the service instance
      def service_class(klass)
        @service_class = klass
      end

      # Gets the current service class
      # @return [Class] returns the service class. Please note this is an internal method.
      def internal_service_class
        @service_class
      end
    end

    # Initializes the service with a hash of params
    # @param [Hash] params The params which are passed to the service
    def initialize(params = {})
      @object = nil
      @successful = false
      @ran = false
      @error = nil
      @service_class = nil

      @params = params
    end

    # Runs the service using 'safe' execution. The @run variable will be set to true, initialize_service and run_service
    # will then be called.
    # @param [Block] block The block which will be called upon the service finishing running
    # @return [BBServices.Service] returns the service instance
    def run(&block)
      set_ran
      begin
        initialize_service
        run_service
      rescue => e
        set_successful(false)
        set_error(e)
      ensure
        call_block(&block)
      end
    end

    # Runs the service using 'unsafe' execution. The @run variable will be set to true,
    # initialize_service and run_service will then be called.
    # @param [Block] block The block which will be called upon the service finishing running
    # @return [BBServices.Service] returns the service instance
    def run!(&block)
      set_ran
      begin
        initialize_service
        run_service!
        call_block(&block)
      rescue => e
        set_successful(false)
        set_error(e)
        raise e
      end
    end

    # An alias to {BBServices::Service}'s run method
    alias call run

    # An alias to {BBServices::Service}'s run! method
    alias call! run!

    # Sets the service_class on the instance. This will override the self.class.internal_service_class.
    # @param [Class] new_service_class The new service class.
    def set_service_class(new_service_class)
      @service_class = new_service_class
    end

    # Sets the service_class on the instance. This will override the self.class.internal_service_class.
    # @param [Class] new_service_class The new service class.
    def service_class=(new_service_class)
      set_service_class(new_service_class)
    end

    # Gets the current service class. This will use @service_class if set, otherwise will fallback to
    # self.class.internal_service_class.
    # @return [Class] new_service_class The new service class.
    def service_class
      @service_class ||= self.class.internal_service_class
    end

    # Sets the params variable (@params) on the service.
    # @param [Hash] new_params The new params Hash.
    def set_params(new_params)
      raise BBServices::ServiceHashTypeError unless new_params.is_a?(Hash)

      @params = new_params
    end

    # Sets the params variable (@params) on the service.
    # @param [Hash] new_params The new params Hash.
    def params=(new_params)
      set_params(new_params)
    end

    # Gets a single param using a key
    # @param [String/Symbol] key The key which is used to find the param
    # @return [Hash] The param found using the key
    def param_for(key)
      param(key)
    end

    # Gets a single param using a key
    # @param [String/Symbol] key The key which is used to find the param
    # @return [Hash] The param found using the key
    def param(key)
      @params[key] if @params
    end

    # Gets the number of params
    # @return [Number] The number of params
    def number_of_params
      @params ? @params.length : 0
    end

    # Returns true/false on if the service has been ran
    # @return [Boolean] True/False value on if the service has been ran
    def ran?
      @ran
    end

    # Returns true / false if the service has any params
    # @return [Boolean] true/false if the service has any params
    def params?
      !!(@params && @params.length)
    end

    # An alias to {BBServices::Service}'s ran? method
    alias run? ran?

    # Returns true/false on if the service did succeed.
    # @return [Boolean] true/false on if the service did succeed.
    def succeeded?
      successful?
    end

    # Returns true/false on if the service was successful.
    # @return [Boolean] true/false on if the service was successful.
    def successful?
      @successful
    end

    # Returns true/false on if the service was unsuccessful. This will always be the inverse of successful?
    # @return [Boolean] true/false on if the service failed.
    def failed?
      !succeeded?
    end

    # Calls the given block if the service was successful
    def success
      yield(self) if succeeded?
    end

    # Calls the given block if the service failed
    def failure
      yield(self) if failed?
    end

    # Calls success on success?, failure on !success?
    # @param [Proc] success The proc to be called upon a successful service
    # @param [Proc] failure
    # @return [Boolean] true/false if the service has any params
    def on(success: proc {}, failure: proc {})
      if successful?
        success.call
      else
        failure.call
      end
    end

    # Returns true / false if the service threw an error
    # @return [Boolean] true/false on if an error has occurred
    def error?
      !!@error
    end

    protected

    # Called upon run / run!, should be overridden in order to setup any variable
    # initalization
    def initialize_service() end

    # Called upon run, should be overridden in order to setup any variable
    # initalization
    def run_service
      set_successful
      set_object(nil)
    end

    # Called upon run, should be overridden in order to setup any variable
    # initalization
    def run_service!
      set_successful
      set_object(nil)
    end

    # Sets the @object instance variable, the object will be accessible via the .object property outside of the service
    # @param obj The object which will be assigned to the @object instance variable
    def set_object(obj)
      @object = obj
    end

    private

    # Sets the internal @ran instance variable
    # @param [Boolean] ran True / False if the service has been ran
    def set_ran(ran = true)
      @ran = ran
    end

    # Sets the internal @successful instance variable
    # @param [Boolean] successful True / False if the service has been successful
    def set_successful(successful = true)
      @successful = successful
    end

    # Sets the internal @error instance variable
    # @param [Error] error The error to be assigned
    def set_error(error)
      @error = error
    end

    # Calls the block which has been passed
    def call_block
      yield(self) if block_given?
    end
  end
end
