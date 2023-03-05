class Admin::StagesController < Admin::BaseController
  load_and_authorize_resource

  def index
  end

  def show
    respond_to do |format|
      format.html {  }
      format.xlsx do
        io_string = Stages::ProgressReport.run!(stage: @stage)

        send_data(
          io_string,
          filename: "ВыгрузкаПоФакультетам-#{I18n.l(Time.current, format: :slug)}.xlsx",
          disposition: "attachment",
          type: Mime::Type.lookup_by_extension(:xlsx)
        )
      end
    end
  end
end
