module Api
  module StudentsApi
    module Stages
      module Teachers
        class RelationsController < BaseController
          def create
            ::Teachers::AsStudent::AddTeacherToRelations.new.call(stage: stage, student: current_kind, teacher: teacher) do |monad|
              monad.success { head :created }
              monad.failure(:validate_input) { respond_with_errors(['Мы не смогли добавить преподавателя. Пожалуйста, обратитесь в техническую поддержку.']) }
              monad.failure(:stage_not_closed_yet) { respond_with_errors(['К сожалению, мы больше не вносим изменения по этому анкетированию']) }
              monad.failure(:teacher_belongs_to_roster) { respond_with_errors(['К сожалению, Вы не можете добавить этого преподавателя в список оцениваемых']) }
              monad.failure { respond_with_errors(['Мы не смогли обработать ваш запрос :( Пожалуйста, обратитесь в техническую поддержку.']) }
            end
          end

          def destroy
            ::Teachers::AsStudent::RemoveTeacherFromRelations.new.call(stage: stage, student: current_kind, teacher: teacher) do |monad|
              monad.success { head :ok }
              monad.failure(:validate_input) { respond_with_errors(['Мы не смогли удалить преподавателя. Пожалуйста, обратитесь в техническую поддержку.']) }
              monad.failure(:stage_not_closed_yet) { respond_with_errors(['К сожалению, мы больше не вносим изменения по этому анкетированию']) }
              monad.failure(:teacher_belongs_to_roster) { respond_with_errors(['К сожалению, Вы не можете удалить этого преподавателя из списка оцениваемых']) }
              monad.failure { respond_with_errors(['Мы не смогли обработать ваш запрос :( Пожалуйста, обратитесь в техническую поддержку.']) }
            end
          end


          private

          def teacher
            @teacher ||= Teacher.find(params[:teacher_id])
          end

          def stage
            @stage ||= Stage.find(params[:stage_id])
          end
        end
      end
    end
  end
end
