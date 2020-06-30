module BBServices
  ##
  # The base class for all services. Handles the basic run loop and general accessors
  class Service
    attr_reader :params, :object, :errors

    def self.run(params = nil, &block)
      self.new(params).tap do |service|
        service.run(&block)
      end
    end

    def self.run!(params = nil, &block)
      self.new(params).tap do |service|
        service.run!(&block)
      end
    end

    def self.service_class(klass)
      @service_class = klass
    end

    def self.get_service_class
      @service_class
    end

    def initialize(params = nil)
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
      # The errors which are returned by the service
      @errors = nil

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
    def run(&block)
      set_ran
      begin
        initialize_service
        internal_validation
        run_service
      rescue StandardError => e
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
        internal_validation
        run_service!
        call_block(&block)
      rescue StandardError => e
        set_successful(false)
        set_error(e)
        raise e
      end
    end

    def set_service_class(value)
      @service_class = value
    end

    ##
    # Sets the service_class instance variable
    def service_class=(value)
      set_service_class(value)
    end

    ##
    # Gets the service_class. This will go instance first, then static
    def service_class
      @service_class || self.class.get_service_class
    end

    def set_params(value)
      @params = value
    end

    def params=(value)
      set_params(value)
    end

    def param_for(key)
      @params[key] if @params
    end

    def ran?
      @ran
    end

    def succeeded?
      (@successful && !errors?)
    end

    def successful?
      (@successful && !errors?)
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

    def errors?
      !!(@errors && @errors.length.positive?)
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
      set_errors([]) unless @errors
      @errors << error
    end

    def set_errors(errors)
      @errors = errors
    end

    def set_successful(successful = true)
      @successful = successful
    end

    def set_ran(ran = true)
      @ran = ran
    end

    private

    def internal_validation
      set_params({}) unless params?
    end

    def call_block
      yield(self) if block_given?
    end
  end
end
