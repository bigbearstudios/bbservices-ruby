# frozen_string_literal: true

require_relative 'bbservices/service'
require_relative 'bbservices/service_chain'
require_relative 'bbservices/service_provider'

# The BBServices namespace.
module BBServices
  class << self
    def chain(*args, &block)
      BBServices::ServiceChain.new.tap do |service_chain|
        service_chain.chain(*args, &block)
      end
    end

    def is_a_service?(service)
      service.is_a?(BBServices::Service)
    end

    def is_not_a_service?(service)
      !BBServices.is_a_service?(service)
    end
  end
end
