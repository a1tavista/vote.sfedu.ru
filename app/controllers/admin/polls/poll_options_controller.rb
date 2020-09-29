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
          monad.success do
            respond_with(:success, 'Вариант ответа успешно добавлен к голосованию')
          end
          monad.failure(:poll_not_started) do
            respond_with(:error, 'Нельзя добавлять варианты к существующему голосованию')
          end
          monad.failure do
            respond_with(:error, 'Во время сохранения варианта ответа возникли ошибки')
          end
        end
      end

      private

      def respond_with(kind, msg)
        flash[kind] = msg
        redirect_to admin_poll_path(@poll)
      end

      def create_params
        params.require(:poll_option).permit!.merge(poll: @poll)
      end
    end
  end
end
