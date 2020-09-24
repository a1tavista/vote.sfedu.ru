module Api
  module StudentsApi
    class PollsController < BaseController
      def index
        @polls = Poll.for_student(current_kind)
      end

      def show
        @poll = Poll.find(params[:id])
      end
    end
  end
end
