module Teachers
  class MergeDuplicates
    attr_reader :pairs

    def initialize
      teachers_to_process = Teacher.where.not(kind: 0)
      duplicates = Teacher.where(kind: 0, encrypted_snils: @teachers_to_process.pluck(:encrypted_snils))

      @pairs = (teachers_to_process + duplicates).group_by(&:encrypted_snils)
    end

    def call
      ActiveRecord::Base.transaction do
        pairs.each do |_hash, pair|
          next if pair.length != 2

          pair.sort! { |a, b| a.kind == 0 ? 0 : 1 }

          Teachers::Operations::MergeRecords.new.call(original: pair[0], duplicate: pair[1])
        end
      end
    end
  end
end
