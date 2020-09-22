module Api
  module StudentsApi
    module Stages
      class TeachersController < BaseController
        def index
          @stage_attendee = StageAttendee.find_or_create_by(stage: stage, student: current_kind)
          @evaluated = ::Teachers::EvaluatedTeachersForStudent.new(stage: stage, student: current_kind).call
          @available = ::Teachers::AvailableTeachersForStudent.new(stage: stage, student: current_kind).call
        end

        private

        def stage
          @stage ||= Stage.find(params[:stage_id])
        end
      end
    end
  end
end
