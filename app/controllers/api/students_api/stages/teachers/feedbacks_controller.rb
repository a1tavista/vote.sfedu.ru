module Api
  module StudentsApi
    module Stages
      module Teachers
        class FeedbacksController < BaseController
          def show
            @teacher = teacher
            @stage = stage
            @questions = stage.questions
            @student_relations = StudentsTeachersRelation.where(
              student: current_kind,
              teacher: teacher,
              semester: stage.semesters
            )
          end

          def create
            call_params = {teacher: teacher, student: current_kind, stage: stage, answers: create_params['answers']}
            ::Teachers::AsStudent::LeaveFeedback.new.call(call_params) do |monad|
              monad.success { head :created }
              monad.failure(:validate_input) { respond_with_errors(['Пожалуйста, убедитесь, что Вы ответили на все вопросы анкеты']) }
              monad.failure(:stage_not_closed_yet) { respond_with_errors(['К сожалению, мы больше не принимаем ответы по этому анкетированию']) }
              monad.failure(:student_not_participated_before) { respond_with_errors(['Кажется, что Вы уже приняли участие в этом опросе']) }
              monad.failure(:student_allowed_to_leave_feedback) { respond_with_errors(['К сожалению, Вы не можете дать оценку этому преподавателю']) }
              monad.failure(:student_filled_all_questions) { respond_with_errors(['Пожалуйста, выберите оценки по каждому из вопросов']) }
              monad.failure { respond_with_errors(['Мы не смогли принять Ваш голос :( Пожалуйста, обратитесь в техническую поддержку.']) }
            end
          end

          private

          def teacher
            @teacher ||= Teacher.find(params[:teacher_id])
          end

          def stage
            @stage ||= Stage.find(params[:stage_id])
          end

          def create_params
            params.require(:feedback).permit!.to_hash
          end
        end
      end
    end
  end
end
