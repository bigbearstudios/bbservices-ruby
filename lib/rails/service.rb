module BBServices
  module Rails
    class Service < BBServices::Service

      attr_reader :associated_params

      def self.run(params = nil, assoc_params = nil, &block)
        self.new(params, assoc_params).tap do |service|
          service.run(&block)
        end
      end

      def self.run!(params = nil, assoc_params = nil, &block)
        self.new(params, assoc_params).tap do |service|
          service.run!(&block)
        end
      end

      def initialize(params = nil, assoc_params = nil)
        super(params)

        @associated_params = assoc_params
      end

      def set_associated_params(value)
        @associated_params = value
      end

      def associated_params=(value)
        set_associated_params(value)
      end

      def associated_param_for(key)
        @associated_params[key] if @associated_params
      end

      def resource
        @object
      end
    end
  end
end
