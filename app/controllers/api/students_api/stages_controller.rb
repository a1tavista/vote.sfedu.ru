module Api
  module StudentsApi
    class StagesController < BaseController
      def index
        @stages = Stage.active
      end
    end
  end
end
