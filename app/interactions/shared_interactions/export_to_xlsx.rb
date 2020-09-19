module SharedInteractions
  class ExportToXlsx < ActiveInteraction::Base
    # Constants
    DEFAULT_FORMAT = {
      color: "black",
      size: 9,
      align: "left",
      valign: "vcenter",
      text_wrap: 1
    }.freeze
    DEFAULT_NUMBER_FORMAT = self::DEFAULT_FORMAT.merge(align: "right")
    DEFAULT_STRING_FORMAT = self::DEFAULT_FORMAT.merge(align: "center")

    # Required params
    string :file_name, default: nil

    # Optional params
    symbol :export_type, default: :stream, desc: "Format of output. Could be `:file` or `:stream`."
    object :path, class: Pathname, default: -> { Rails.root.join("tmp", "#{file_name}.xlsx") }

    # Validations
    validates :export_type, presence: true, acceptance: {accept: [:file, :stream]}
    validates :file_name, presence: true, if: -> { export_type == :file }

    # Callbacks

    # Execute
    def execute
      raise NotImplementedError
    end

    protected

    def open_workbook
      if export_type == :stream
        @io_string = StringIO.new
      end
      WriteXLSX.new(@io_string || path)
    end

    def close_workbook(workbook)
      workbook.close
      if export_type == :file
        path
      elsif export_type == :stream
        @io_string.string
      end
    end
  end
end
