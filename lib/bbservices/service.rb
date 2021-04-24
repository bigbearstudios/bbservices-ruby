# frozen_string_literal: true

module BBServices
  ##
  # The base class for all services. Handles the basic run loop and general accessors
  class Service
    attr_reader :params, :object, :error

    class << self
      # Creates a new service class, then calls run
      def run(params = {}, &block)
        new(params).tap do |service|
          service.run(&block)
        end
      end

      ##
      # Creates a new service class, then calls run!
      def run!(params = {}, &block)
        new(params).tap do |service|
          service.run!(&block)
        end
      end

      ##
      # Sets the service class
      def service_class(klass)
        @service_class = klass
      end

      def get_service_class
        @service_class
      end
    end

    def initialize(params = {})
      ##
      # The object which will be assigned to the service
      @object = nil

      ##
      # The state of success, was the service successful
      @successful = false

      ##
      # The state of the run, has the service being ran
      @ran = false

      ##
      # The error that has been throw by the service
      @error = nil

      ##
      # The service class stored on the instance. This will override the
      # service class set statically
      @service_class = nil

      ##
      # The params passed to the resource
      @params = params
    end

    ##
    # This runs the safe version of the service. E.g. Will rescue on exception
    # and set the error attribute
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

    ##
    # This runs the unsafe version of the service. E.g. Exceptions will be thrown
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

    ##
    # Sets the service_class instance variable
    def service_class=(value)
      @service_class = value
    end

    ##
    # Gets the service_class. This will go instance first, then static
    def service_class
      @service_class ||= self.class.get_service_class
    end

    def set_params(value)
      @params = value
    end

    def params=(value)
      set_params(value)
    end

    def param_for(key)
      param(key)
    end

    def param(key)
      @params[key] if @params
    end

    def number_of_params
      @params ? @params.length : 0
    end

    def ran?
      @ran
    end

    def succeeded?
      successful?
    end

    def successful?
      @successful
    end

    def failed?
      !succeeded?
    end

    def success(&block)
      call_block(&block) if succeeded?
    end

    def failure(&block)
      call_block(&block) if failed?
    end

    def error?
      !!@error
    end

    def params?
      !!@params
    end

    protected

    def initialize_service() end

    def run_service
      set_successful
      set_object(nil)
    end

    def run_service!
      set_successful
      set_object(nil)
    end

    def set_object(obj)
      @object = obj
    end

    def set_error(error)
      @error = error
    end

    def set_successful(successful = true)
      @successful = successful
    end

    def set_ran(ran = true)
      @ran = ran
    end

    private

    def call_block
      yield(self) if block_given?
    end
  end
end
