# frozen_string_literal: true

require_relative 'bbservices/service'
require_relative 'bbservices/service_chain'
require_relative 'bbservices/service_provider'

# The BBServices namespace.
module BBServices
  def self.chain(params = {}, &block)
    BBServices::ServiceChain.new.tap do |service_chain|
      service_chain.chain(params, &block)
    end
  end
end
