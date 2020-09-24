module Admin
  module Support
    class MergeFacultiesController < Admin::BaseController
      def show
        @faculties = Faculty.all.order(name: :asc)
      end

      def execute
        raise CanCan::AccessDenied unless can?(:merge_faculties, current_user)

        ::Faculties::AsAdmin::MergeDuplicatedFacultyToAnotherFaculty.new.call(call_params) do |monad|
          monad.success { puts 'ok' }
          monad.failure { puts 'failure' }
        end
      end

      private

      def call_params
        {
          faculty: Faculty.find(execute_params[:faculty_id]),
          duplicated_faculty: Faculty.find(execute_params[:duplicated_faculty_id])
        }
      end

      def execute_params
        params.require(:tool).permit!
      end
    end
  end
end
