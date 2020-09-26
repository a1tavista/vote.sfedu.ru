module OneCApi
  class FetchStudentTeachersRelations
    include OneCApi::SoapConnectable
    include OneCApi::Constants

    operations :get_stud_preps

    # TODO: Завернуть в монаду
    def call(external_id:)
      all_info(external_id)
    end

    private

    def all_info(external_id)
      fetch_relations_data(external_id).map { |teacher| process_teacher(teacher) }
    end

    def process_teacher(teacher_data)
      {
        external_id: teacher_data[:prep_kod],
        name: teacher_data[:prep_fio],
        snils: teacher_data[:prep_snils],
        relations: normalize_edu_data(teacher_data[:edu_year])
      }
    end

    def normalize_edu_data(data)
      Array.wrap(data).flat_map { |year|
        year[:semester] = Array.wrap(year[:semester])
        year[:semester].map! do |semester|
          semester[:year_begin], semester[:year_end] = year[:edu_year_name].split(" - ")
          semester[:kind] = SEMESTER_MAPPING.fetch(semester[:semester_name], :fall)
          semester[:disc_name] = Array.wrap(semester[:disc_name])
          semester.except(:semester_name)
        end
        year[:semester]
      }
    end

    def fetch_relations_data(external_id)
      response = get_stud_preps(message: {'StudentID': external_id}).body
      Array.wrap(response.dig(:get_stud_preps_response, :return, :stud_preps, :prep))
    end
  end
end
