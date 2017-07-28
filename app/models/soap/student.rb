class Soap::Student
  include SoapConnectable

  operations :get_zach_list, :get_stud_preps, :get_study_info, :get_student_info, :get_stud_rup

  def self.years_for_student(external_id)
    get_zach_list(message: {'StudentID': external_id}).body
  end

  def self.personal_info(external_id)
    response = get_student_info(message: {'StudentID': external_id}).body
    handled_response = response[:get_student_info_response][:return][:student_info]
    {
      name: handled_response[:fio],
      grade_books: handled_response[:study_inf].to_a.map { |grade_book| grade_book[:zachetka] }.uniq
    }
  end

  def self.study_info(grade_book_id)
    response = get_study_info(message: {'ZachNum': grade_book_id}).body
    handled_response = response[:get_study_info_response][:return][:study_infо]
    # TODO: Почистить данные
    {
      grade_book_id: grade_book_id,
      time_type: handled_response[:f_obuch], # TODO: Автоматическая трансляция в форму обучения
      level: handled_response[:ur_podg], # TODO: Автоматическая трансляция в уровень обучения
      major: handled_response[:napr_podg_name],
      faculty: handled_response[:place][:faculty_name],
      grade_num: handled_response[:place][:kurs], # TODO: Автоматическая трансляция в число
      group_num: handled_response[:place][:group]
    }
  end

  def self.all_info(external_id)
    personal = self.personal_info(external_id)
    personal[:study_info] = personal[:grade_books].map { |grade_book_id| self.study_info(grade_book_id) }
    personal.except(:grade_books)
  end
end
