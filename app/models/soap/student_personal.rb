class Soap::StudentPersonal
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
      grade_books: Array.wrap(handled_response[:study_inf]).map { |grade_book| grade_book[:zachetka] }.uniq
    }
  end

  def self.study_info(grade_book_id)
    response = get_study_info(message: {'ZachNum': grade_book_id}).body
    handled_response = response[:get_study_info_response][:return][:study_infо]

    {
      external_id: grade_book_id,
      time_type: detect_type(handled_response[:f_obuch]),
      grade_level: detect_level(handled_response[:ur_podg]),
      major: handled_response[:napr_podg_name] || "empty",
      faculty: Faculty.find_or_create_with(name: handled_response[:place][:faculty_name]),
      grade_num: detect_grade_num(handled_response[:place][:kurs]),
      group_num: handled_response[:place][:group] || "empty"
    }
  end

  def self.all_info(external_id)
    personal = personal_info(external_id)
    personal[:study_info] = personal[:grade_books].map { |grade_book_id| study_info(grade_book_id) }
    personal.except(:grade_books)
  end

  def self.detect_type(raw)
    list = {
      "Дистанционная" => :distant,
      "Очная" => :fulltime,
      "Очно-заочная" => :parttime,
      "Заочная" => :extramural
    }
    list.fetch(raw, :other_time_type)
  end

  def self.detect_level(raw)
    {
      "61" => :applied_bachelor,
      "62" => :academic_bachelor,
      "65" => :specialist,
      "68" => :master,
      "72" => :postgraduate
    }.fetch(raw, :other_grade_level)
  end

  def self.detect_grade_num(raw)
    {
      "Нулевой" => 0,
      "Первый" => 1,
      "Второй" => 2,
      "Третий" => 3,
      "Четвертый" => 4,
      "Пятый" => 5,
      "Шестой" => 6,
      "Седьмой" => 7,
      "Восьмой" => 8,
      "Девятый" => 9,
      "Десятый" => 10,
      "Одиннадцатый" => 11
    }.fetch(raw, 0)
  end

end
