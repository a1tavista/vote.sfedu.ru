module Stages
  class ProgressReport < BaseReport
    record :stage

    def execute
      workbook = open_workbook
      formats = define_available_formats(workbook)
      worksheet = add_worksheet(workbook)
      adjust_column_sizes(worksheet)
      add_worksheet_heading(worksheet, 0, formats)

      row = 1

      Stages::ProgressReportByFaculties.new.call(stage: stage).values.each do |entity|
        worksheet.set_row(row, 30)
        write_data(worksheet, row, formats, {
          faculty: entity[:faculty].name,
          students: entity[:students],
          participations: entity[:participations],
          participations_per_student: entity[:participations_per_student]
        })
        row += 1
      end

      worksheet.write(row, 0, "Итого:", formats[:cell_number])
      worksheet.write(row, 1, "=SUM(B2:B#{row})", formats[:cell_number_highlighted])
      worksheet.write(row, 2, "=SUM(C2:C#{row})", formats[:cell_number_highlighted])

      close_workbook(workbook)
    end

    private

    def add_worksheet(workbook)
      workbook.add_worksheet("Стадия анкетирования")
    end

    def define_available_formats(workbook)
      workbook.set_custom_color(40, "#F5F5DC")

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
      worksheet.set_column(1, 3, 20)
    end

    def add_worksheet_heading(worksheet, first_row, formats)
      worksheet.set_row(first_row, 50)
      worksheet.write(first_row, 0, "Факультет", formats[:heading_centered])
      worksheet.write(first_row, 1, "Студенты", formats[:heading_centered])
      worksheet.write(first_row, 2, "Заполненные анкеты", formats[:heading_centered])
      worksheet.write(first_row, 3, "Анкет на студента", formats[:heading_centered])
    end

    def write_data(worksheet, row, formats, data)
      worksheet.write(row, 0, data[:faculty], formats[:cell])
      worksheet.write(row, 1, data[:students], formats[:cell_number])
      worksheet.write(row, 2, data[:participations], formats[:cell_number])
      worksheet.write(row, 3, data[:participations_per_student], formats[:cell_number])
    end
  end
end
