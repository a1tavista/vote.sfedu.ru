module Api
  module StudentsApi
    class PollsController < BaseController
      def index
        @polls = Poll.all
      end

      def show
        @poll = Poll.find(params[:id])
      end
    end
  end
end
