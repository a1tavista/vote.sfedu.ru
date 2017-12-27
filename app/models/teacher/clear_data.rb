class Teacher::ClearData
  def initialize; end

  def process!
    ActiveRecord::Base.transaction do
      remove_empty_records
      nullify_external_id_for_regular_teachers
      move_external_id_to_snils_for_irregular_teachers
      clear_snils_for_regular_teachers
      encrypt_snils_for_regular_teachers
    end
  end

  def remove_empty_records
    Teacher.where(name: nil).destroy_all
  end

  def nullify_external_id_for_regular_teachers
    Teacher.where(kind: 0).update_all(external_id: nil)
  end

  def move_external_id_to_snils_for_irregular_teachers
    Teacher.where.not(kind: 0).find_each do |t|
      t.update(encrypted_snils: t.external_id)
    end
  end

  def clear_snils_for_regular_teachers
    Teacher.where(kind: 0).find_each(&:clear_snils!)
  end

  def encrypt_snils_for_regular_teachers
    Teacher.where(kind: 0).find_each(&:encrypt_snils!)
  end
end
