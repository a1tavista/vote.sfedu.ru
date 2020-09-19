class Admin::Reports::TeachersController < Admin::BaseController
  def index
    respond_to do |format|
      format.xlsx do
        io_string = Teachers::AsAdmin::ResultsReportByStage.run!(stage: Stage.current || Stage.second_to_last)

        send_data(
          io_string,
          filename: "Результаты-#{I18n.l(Time.current, format: :slug)}.xlsx",
          disposition: "attachment",
          type: Mime::Type.lookup_by_extension(:xlsx)
        )
      end
    end
  end

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
