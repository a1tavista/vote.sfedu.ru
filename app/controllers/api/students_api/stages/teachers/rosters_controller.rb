module Api
  module StudentsApi
    module Stages
      module Teachers
        class RostersController < BaseController
          def show
            @available_teachers = ::Teachers::AvailableTeachersFromRoster.new(student: current_kind, stage: stage).call
            @selected_teachers = ::Teachers::SelectedTeachersFromRoster.new(student: current_kind, stage: stage).call
          end

          private

          def stage
            @stage ||= Stage.find(params[:stage_id])
          end
        end
      end
    end
  end
end
