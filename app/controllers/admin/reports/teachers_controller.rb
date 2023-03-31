class Admin::Reports::TeachersController < Admin::BaseController
  def index
    respond_to do |format|
      format.xlsx do
        io_string = ::Stages::ResultsReport.run!(stage: Stage.current || Stage.last)

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
    @report = ::Teachers::NotEnoughParticipationsReport
      .new(Stage.current)
      .paginate(page: params[:page], per: 20)
      .build
  end

  def lack_of_students
    @report = ::Teachers::NotEnoughStudentsReport
      .new(Stage.current)
      .paginate(page: params[:page], per: 20)
      .build
  end
end
