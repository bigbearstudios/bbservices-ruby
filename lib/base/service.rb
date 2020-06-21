module BBServices
  class Service
    # service_class
    # Allows the setting of a service class which can be used through-out the service
    def self.service_class(klass)
      @service_class = klass
    end

    # initialize
    # initializes the service
    def initialize

      # object
      # The object which is managed by the service
      @object = nil

      # successful
      # Has the service been successful in terms of the run loop
      @successful = false

      # errors
      # The errors which have been thrown by the service (Or the underlying models)
      @errors = nil

      # service_class
      # The service class which will be created
      @service_class = nil
    end

    # service_class
    # Allows the setting of the internal service class which overrides the
    # class set using the static typing
    def service_class=(klass)
      @service_class = klass
    end

    # service_class
    # Gets the service class which can either be the internal variable or the static
    def service_class
      @service_class ? @service_class : self.class.instance_variable_get(:@service_class)
    end

    #
    # Run methods

    def run(&block)
      begin
        initialize_service
        run_service
      rescue
        @successful = false
      ensure
        call_block(&block)
      end
    end

    def run!(&block)
      initialize_service
      run_service!
      call_block(&block)
    end

    #
    # Param Accessors

    def params=(params)
      @params = params
    end

    def associated_params=(params)
      @associated_params = params
    end

    def params
      @params
    end

    def associated_params
      @associated_params
    end

    def param_for(key)
      if @params
        @params[key]
      end
    end

    def associated_param_for(key)
      if @associated_params
        @associated_params[key]
      end
    end

    def succeeded?
      (@successful && !has_errors? )
    end

    def failed?
      !succeeded?
    end

    def success(&block)
      if succeeded?
        yield
      end
    end

    def failure(&block)
      if failed?
        yield
      end
    end

    def object
      @object
    end

    def has_errors?
      @errors && @errors.length > 0
    end

    protected

    def initialize_service

    end

    def run_service
      @successful = true
    end

    def run_service!
      @successful = true
    end

    private

    def call_block(&block)
      if block_given?
        yield(self)
      end
    end
  end
end
