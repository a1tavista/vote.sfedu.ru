module OneCApi
  class FetchStudentPersonalData
    include OneCApi::SoapConnectable
    include OneCApi::Constants

    operations :get_zach_list, :get_stud_preps, :get_study_info, :get_student_info, :get_stud_rup

    # TODO: Завернуть в монаду
    def call(external_id:)
      collect_data_for_student(external_id)
    end

    private

    def collect_data_for_student(external_id)
      personal = personal_info(external_id)
      personal[:study_info] = personal[:grade_books].map { |grade_book_id| study_info(grade_book_id) }
      personal.except(:grade_books)
    end

    def personal_info(external_id)
      handled_response = fetch_personal_info(external_id)

      {
        name: handled_response[:fio],
        grade_books: Array.wrap(handled_response[:study_inf]).map { |grade_book| grade_book[:zachetka] }.uniq
      }
    end

    def study_info(grade_book_id)
      handled_response = fetch_grade_book_info(grade_book_id)

      {
        external_id: grade_book_id,
        time_type: TIME_TYPE_MAPPING.fetch(handled_response[:f_obuch], :other_time_type),
        grade_level: GRADUATING_LEVEL_MAPPING.fetch(handled_response[:ur_podg], :other_grade_level),
        major: handled_response[:napr_podg_name] || "empty",
        # TODO: Устранить протечку абстракции
        faculty: Faculty.find_or_create_with(name: handled_response[:place][:faculty_name]),
        grade_num: GRADE_NUM_MAPPING.fetch(handled_response[:place][:kurs], 0),
        group_num: handled_response[:place][:group] || "empty"
      }
    end

    def fetch_grade_book_info(grade_book_id)
      response = get_study_info(message: {'ZachNum': grade_book_id}).body
      # BE AWARE! 1C returns non-ASCII and ASCII characters in one string here (study_infо).
      response.dig(:get_study_info_response, :return, :study_infо)
    end

    def fetch_personal_info(external_id)
      response = get_student_info(message: {'StudentID': external_id}).body
      response.dig(:get_student_info_response, :return, :student_info)
    end
  end
end
