module Admin
  module Reports
    class FacultiesController < BaseController
      def index
        respond_to do |format|
          format.xlsx do
            io_string = Stages::ProgressReport.run!(stage: Stage.current || Stage.last)

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
  end
end
