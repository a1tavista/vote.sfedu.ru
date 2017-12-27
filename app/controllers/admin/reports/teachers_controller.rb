class Admin::Reports::TeachersController < Admin::BaseController
  def lack_of_participations
    @report = ::TeachersReports::NotEnoughParticipationsReport
                .new(Stage.current)
                .paginate(page: params[:page], per: 20)
                .build
  end

  def lack_of_students
    @report = ::TeachersReports::NotEnoughStudentsReport
                .new(Stage.current)
                .paginate(page: params[:page], per: 20)
                .build
  end
end
