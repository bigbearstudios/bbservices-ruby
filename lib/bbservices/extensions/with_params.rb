module BBServices
  module Extensions
    # Developer Notes
    # The module WithParams hasn't been decided if it will enter into a production
    # state due to the confusion over *args vs *kwargs

    # module WithParams

    #   # Default initalizer override which takes in the params. 
    #   # This will run through the run / run! methods which can take these params
    #   def initialize(*args, **kwargs)
    #     @params = initialization_params
    #   end

    #   protected

    #   # Returns true / false if the service has any params
    #   # @return [Boolean] true/false if the service has any params
    #   def has_params?
    #     @params.length > 0
    #   end

    #   def number_of_params
    #     @params.count
    #   end

    #   #
    #   # Developer Notes
    #   # Not sure if this functionality will be used at all...

    #   # # Sets the service_class on the instance. This will override the self.class.internal_service_class.
    #   # # @param [Class] new_service_class The new service class.
    #   # def set_service_class(new_service_class)
    #   #   @service_class = new_service_class
    #   # end

    #   # # Sets the service_class on the instance. This will override the self.class.internal_service_class.
    #   # # @param [Class] new_service_class The new service class.
    #   # def service_class=(new_service_class)
    #   #   set_service_class(new_service_class)
    #   # end

    #   # # Gets the current service class. This will use @service_class if set, otherwise will fallback to
    #   # # self.class.internal_service_class.
    #   # # @return [Class] new_service_class The new service class.
    #   # def service_class
    #   #   @service_class ||= self.class.internal_service_class
    #   # end

    # end
  end
end