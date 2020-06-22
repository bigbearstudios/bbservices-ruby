module BBServices
  module Rails
    class CreateTransactioned < Create

      ##
      #
      def run_service
        service_class.transaction {
          internal_save {
            save
          }
        }
      end

      ##
      #
      def run_service!
        service_class.transaction {
          internal_save {
            save!
          }
        }
      end
    end
  end
end
