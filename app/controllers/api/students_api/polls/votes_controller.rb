module Api
  module StudentsApi
    module Polls
      class VotesController < BaseController
        def new
          @poll_options = poll.options
        end

        def create
          ::Polls::AsStudent::LeaveVoice.new.call(create_params) do |monad|
            monad.success { head :created }
            monad.failure(:poll_not_closed_yet) { respond_with_errors(['К сожалению, данное голосование больше не принимает голоса']) }
            monad.failure(:student_not_participated_before) { respond_with_errors(['Кажется, что Вы уже приняли участие в этом опросе'])  }
            monad.failure(:student_allowed_to_leave_voice) { respond_with_errors(['К сожалению, Вы не можете принимать участие в этом опросе']) }
            monad.failure { respond_with_errors(['Мы не смогли принять Ваш голос :( Пожалуйста, обратитесь в техническую поддержку.']) }
          end
        end

        private

        def poll
          @poll ||= Poll.find(params[:poll_id])
        end

        def create_params
          {
            student: current_kind,
            poll: poll,
            poll_option: poll.options.find(params[:poll_option_id])
          }
        end
      end
    end
  end
end
