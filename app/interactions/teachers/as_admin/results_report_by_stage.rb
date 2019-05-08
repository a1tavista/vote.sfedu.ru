module Teachers
  module AsAdmin
    class ResultsReportByStage < SharedInteractions::ExportToXlsx
      record :stage

      def execute
        workbook = open_workbook
        formats = define_available_formats(workbook)
        worksheet = add_worksheet(workbook)
        adjust_column_sizes(worksheet)
        add_worksheet_heading(worksheet, 0, formats)

        row = 1

        Teacher.order(name: :asc).find_each do |teacher|
          worksheet.set_row(row, 30)

          results = Teacher::Results.new(teacher, stage).full_info

          write_data(worksheet, row, formats, {
            name: teacher.name,
            external_id: teacher.external_id,
            encrypted_snils: teacher.encrypted_snils,
            participations_count: results[:participations_count],
            rating_of_questions: results[:rating_by_questions].map { |q| q[:rating].try(:round, 1) },
            avg_rating: results[:mean_rating_of_questions].try(:round, 1)
          })
          row += 1
        end

        close_workbook(workbook)
      end

      protected

      def add_worksheet(workbook)
        workbook.add_worksheet("Стадия анкетирования")
      end

      def define_available_formats(workbook)
        workbook.set_custom_color(40, '#F5F5DC')

        {
          heading_centered: workbook.add_format(DEFAULT_STRING_FORMAT.merge(bold: 1)),
          heading_centered_highlighted: workbook.add_format(DEFAULT_STRING_FORMAT.merge(pattern: 1, border: 1, bg_color: 40, bold: 1)),
          cell: workbook.add_format(DEFAULT_FORMAT),
          cell_centered: workbook.add_format(DEFAULT_STRING_FORMAT),
          cell_number: workbook.add_format(DEFAULT_NUMBER_FORMAT),
          cell_highlighted: workbook.add_format(DEFAULT_NUMBER_FORMAT.merge(pattern: 1, border: 1, bg_color: 40)),
          cell_centered_highlighted: workbook.add_format(DEFAULT_NUMBER_FORMAT.merge(pattern: 1, border: 1, bg_color: 40)),
          cell_number_highlighted: workbook.add_format(DEFAULT_NUMBER_FORMAT.merge(pattern: 1, border: 1, bg_color: 40))
        }
      end

      def adjust_column_sizes(worksheet)
        # Hide first column because this is an most important column in offer template
        worksheet.set_column(0, 0, 60)
        worksheet.set_column(1, 1, 40)
        worksheet.set_column(2, 3, 20)
        worksheet.set_column(4, 4, 60)
        worksheet.set_column(5, 5, 20)
      end

      def add_worksheet_heading(worksheet, first_row, formats)
        worksheet.set_row(first_row, 50)
        worksheet.write(first_row, 0, 'Преподаватель', formats[:heading_centered])
        worksheet.write(first_row, 1, 'SHA1(СНИЛС)', formats[:heading_centered])
        worksheet.write(first_row, 2, 'Идентификатор 1С', formats[:heading_centered])
        worksheet.write(first_row, 3, 'Число респондентов', formats[:heading_centered])
        worksheet.write(first_row, 4, 'Оценка по критериям', formats[:heading_centered])
        worksheet.write(first_row, 5, 'Средняя оценка', formats[:heading_centered])
      end

      def write_data(worksheet, row, formats, data)
        worksheet.write(row, 0, data[:name], formats[:cell])
        worksheet.write(row, 1, data[:encrypted_snils], formats[:cell_number])
        worksheet.write_string(row, 2, data[:external_id] || 'none', formats[:cell_number])
        worksheet.write(row, 3, data[:participations_count], formats[:cell_number])
        worksheet.write(row, 4, data[:rating_of_questions].to_s, formats[:cell_number])
        worksheet.write(row, 5, data[:avg_rating], formats[:cell_number])
      end
    end
  end
end
