require 'csv'

namespace :merge do
  task :teachers => :environment do

    sql = <<-SQL
      SELECT 
        id, external_id, kind, name, hashed_snils, snils
      from teachers
      where hashed_snils in (SELECT hashed_snils from teachers group by hashed_snils having count(*) > 1)
      order by name
    SQL
    results = ActiveRecord::Base.connection.execute(sql)

    dups = results.to_a.map do |row|
      snils = row['snils'].sub(' ', '').sub('-', '').sub('-', '')

      if snils.length == 11
        snils = Digest::SHA1.hexdigest(snils)
        Teacher.find_by_id(row['id']).update(hashed_snils: snils)
      else
        Teacher.find_by_id(row['id']).update(hashed_snils: row['snils'])
      end

      {
        id: row['id'],
        external_id: row['external_id'],
        hashed_snils: row['hashed_snils'],
        name: row['name'],
        duplicate: row['hashed_snils'] == row['snils'],
        kind: row['kind'],
      }
    end.group_by { |r| r[:hashed_snils] }

    dups.each_pair do |key, pair|
      pair.sort! { |a, b| (a[:duplicate]) ? 1 : 0 }
      # ActiveRecord::Base.transaction do
      #   StudentsTeachersRelation.all.where(teacher_id: pair[1][:id]).update(teacher_id: pair[0][:id])
      #   Participation.all.where(teacher_id: pair[1][:id]).update(teacher_id: pair[0][:id])
      #   # Answer.all.where(teacher_id: pair[1]).each do |answer|
      #   #   byebug
      #   # end
      #   ActiveRecord::Rollback
      #   # raise Exception
      # end
      # Answer.all.where(teacher_id: pair[1][:id]).each do |a1|
      #   a0 = Answer.where(question_id: a1.question_id, teacher_id: pair[0][:id]).first
      #   next if a0.nil?
      #   r0 = a0.ratings
      #   r1 = a1.ratings
      #   a0.update(ratings: r0.zip(r1).map { |p| p[0] + p[1] })
      # end
      Teacher.find_by_id(pair[1][:id]).update(enabled: false)
      Teacher.find_by_id(pair[0][:id]).update(kind: pair[1][:kind])
    end


  end
end
