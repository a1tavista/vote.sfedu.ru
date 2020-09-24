module Admin
  module Polls
    class PollOptionsController < Admin::BaseController
      authorize_resource class: 'Poll::Option'

      def new
        @poll = Poll.find(params[:poll_id])
        @poll_option = Poll::Option.new
      end

      def create
        @poll = Poll.find(params[:poll_id])
        ::Polls::AsAdmin::AddOptionToPoll.new.call(create_params.to_h) do |monad|
          monad.success { redirect_to admin_poll_path(@poll) }
          monad.failure { redirect_to admin_poll_path(@poll) }
        end
      end

      private

      def create_params
        params.require(:poll_option).permit!.merge(poll: @poll)
      end
    end
  end
end
