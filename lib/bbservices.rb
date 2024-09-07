# frozen_string_literal: true

require_relative 'bbservices/service'
require_relative 'bbservices/service_chain'
require_relative 'bbservices/service_provider'

require_relative 'bbservices/extensions/with_params'

# The BBServices namespace. Provides helper methods to aid with
# service resolution
module BBServices

  class ServiceMustRunBeforeChainingError < StandardError
    def message
      'BBServices - Service must be ran before chaining via then can occur'
    end
  end

  class ServiceExpectedError < StandardError
    def message
      'BBServices - A service must be returned from the given block'
    end
  end

  class << self

    # Returns true if a BBServices::Service is passed, false for all other types
    def is_a_service?(service)
      service.is_a?(BBServices::Service)
    end

     # Returns false if a BBServices::Service is passed, true for all other types
    def is_not_a_service?(service)
      !BBServices.is_a_service?(service)
    end
  end
end
