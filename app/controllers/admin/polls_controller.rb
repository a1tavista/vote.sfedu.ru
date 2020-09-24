module Admin
  class PollsController < Admin::BaseController
    load_and_authorize_resource

    def new
      @poll = Poll.new
      @faculties = Faculty.all.order(name: :asc)
    end

    def create
      ::Polls::AsAdmin::CreatePoll.new.call(create_params.to_h) do |monad|
        monad.success { redirect_to admin_polls_path }
        monad.failure { redirect_to new_admin_poll_path }
      end
    end

    def index
    end

    def show
      @options = @poll.options
    end

    private

    def create_params
      parameters = params.require(:poll).permit!

      parameters[:faculty_ids] = parameters[:faculty_ids].map(&:presence).compact.map(&:to_i)

      parameters
    end
  end
end
