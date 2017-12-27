require 'csv'

namespace :import do
  desc 'Updates the ruby-advisory-db and runs audit'
  task :teachers => :environment do
    path = Rails.root.join('data', 'new_teachers.csv')
    kinds = [:physical_education, :foreign_language]
    CSV.foreach(path, col_sep: ';', headers: true, skip_blanks: true) do |row|
      # teacher = Teacher.find_or_create_by!(external_id: row[1]) do |t|
      #   t.name = row[0]
      #   t.snils = row[1]
      #   t.kind = row[2].to_i
      # end

      h = {
        1 => :physical_education,
        2 => :foreign_language
      }
      Teacher.find_by(external_id: row[1])&.update(kind: h[row[2].to_i])
    end
  end
end
