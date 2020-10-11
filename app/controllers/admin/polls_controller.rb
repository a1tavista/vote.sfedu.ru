module Admin
  class PollsController < Admin::BaseController
    load_and_authorize_resource

    def new
      @poll = Poll.new
      @faculties = Faculty.all.order(name: :asc)
    end

    def create
      ::Polls::AsAdmin::CreatePoll.new.call(create_params.to_h) do |monad|
        monad.success do |result|
          respond_with(:success, 'Голосование успешно создано')
          redirect_to admin_poll_path(result[:poll])
        end
        monad.failure(:starts_in_future) do
          respond_with(:error, 'Пожалуйста, укажите дату не раньше завтрашней')
        end
        monad.failure(:dates_are_valid) do
          respond_with(:error, 'Пожалуйста, убедитесь, что дата начала предшествует дате завершения')
        end
        monad.failure(:all_faculties_are_present) do
          respond_with(:error, 'Пожалуйста, убедитесь, что вы выбрали факультеты, которые могут участвовать в голосовании')
        end
        monad.failure do
          respond_with(:error, 'Во время сохранения опроса возникли ошибки')
          redirect_to new_admin_poll_path
        end
      end
    end

    def index
    end

    def show
      @options = @poll.options
    end

    def destroy
      ::Polls::AsAdmin::RemovePoll.new.call(poll: @poll) do |monad|
        monad.success do |result|
          respond_with(:success, 'Опрос успешно удален')
          redirect_to admin_polls_path
        end

        monad.failure do
          respond_with(:error, 'К сожалению, уже невозможно удалить этот опрос')
          redirect_to admin_poll_path(@poll)
        end
      end
    end

    private

    def respond_with(kind, msg)
      flash[kind] = msg
    end

    def create_params
      parameters = params.require(:poll).permit!

      parameters[:faculty_ids] = parameters[:faculty_ids].map(&:presence).compact.map(&:to_i)

      parameters
    end
  end
end
