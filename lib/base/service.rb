module BBServices

  ##
  # This class handles the building of a basic / generic service
  class Service

    def self.service_class(klass)
      @service_class = klass
    end

    def initialize
      @object = nil

      @successful = false

      @ran = false;

      @errors = nil

      @service_class = nil
    end

    def service_class=(klass)
      @service_class = klass
    end

    def service_class
      @service_class ? @service_class : self.class.instance_variable_get(:@service_class)
    end

    def run(&block)
      set_ran
      begin
        initialize_service
        run_service
      rescue StandardError => e
        set_successful(false)
        set_error(e)
      ensure
        call_block(&block)
      end
    end

    def run!(&block)
      set_ran
      begin
        initialize_service
        run_service!
        call_block(&block)
      rescue StandardError => e
        set_successful(false)
        set_error(e)
        raise e
      end
    end

    def params=(params)
      if params
        @params = params
      end
    end

    def associated_params=(params)
      if params
        @associated_params = params
      end
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

    def ran?
      @ran
    end

    def succeeded?
      (@successful && !has_errors? )
    end

    def successful?
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

    def errors
      @errors
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

    def set_error(error)
      if !@errors
        @errors = []
      end

      @errors << error
    end

    def set_successful(successful = true)
      @successful = successful
    end

    def set_ran(ran = true)
      @ran = ran
    end

    private

    def call_block(&block)
      if block_given?
        yield(self)
      end
    end
  end
end
