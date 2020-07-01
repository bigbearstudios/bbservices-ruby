module BBServices
  module Rails
    class CreateTransactioned < Create

      def run_service
        service_class.transaction do
          internal_pre_save
          save
          internal_post_save
        end
      end

      def run_service!
        service_class.transaction do
          internal_pre_save
          save!
          internal_post_save
        end
      end
    end
  end
end
