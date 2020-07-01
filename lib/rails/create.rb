module BBServices
  module Rails
    class Create < New
      protected

      ##
      # Allows functionality to be added before the save of the object
      def before_save() end

      ##
      # Saves the object. When overridden should save the @object to the database
      def save
        @successful = @object.save
        @errors = @object.errors
      end

      def save!
        @successful = @object.save!
      end

      def after_save() end

      ##
      # Runs the service. This involves calling internal_build, before_save,
      # save, after_save
      def run_service
        internal_pre_save
        save
        internal_post_save
      end

      def run_service!
        internal_pre_save
        save!
        internal_post_save
      end

      def internal_pre_save
        internal_build
        before_save
      end

      def internal_post_save
        after_save
      end
    end
  end
end
