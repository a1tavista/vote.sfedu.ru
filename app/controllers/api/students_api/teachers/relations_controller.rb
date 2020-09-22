module Api
  module StudentsApi
    module Teachers
      class RelationsController < BaseController
        def new
          teachers = Teacher.all.order(name: :asc)
          @physical_teachers = teachers.where(kind: :physical_education)
          @lang_teachers = teachers.where(kind: :foreign_language)
        end

        def create
          Teachers::AsStudent::ChooseCustomTeachers.run(
            student: current_kind,
            lang_teacher_ids: teachers_params[:lang_teacher_ids].to_a,
            physical_teacher_ids: teachers_params[:physical_teacher_ids].to_a
          )
        end

        def destroy_all
          Teachers::AsStudent::ResetTeachersList.run(student: current_kind)
        end

        private

        def teachers_params
          params.require(:student).permit(lang_teacher_ids: [], physical_teacher_ids: [])
        end
      end
    end
  end
end
