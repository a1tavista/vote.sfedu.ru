class Soap::StudentTeachers
  include SoapConnectable

  operations :get_stud_preps

  def self.all_info(external_id)
    response = get_stud_preps(message: {'StudentID': external_id}).body
    handled_response = response[:get_stud_preps_response][:return][:stud_preps][:prep]
    handled_response.map do |teacher|
      process_teacher(teacher)
    end
  end

  def self.process_teacher(teacher)
    {
      external_id: teacher[:prep_kod],
      name: teacher[:prep_fio],
      snils: teacher[:prep_snils],
      relations: normalize_edu_data(teacher[:edu_year])
    }
  end

  def self.normalize_edu_data(data)
    years = Array.wrap(data)
    years.map { |year|
      year[:semester] = Array.wrap(year[:semester])
      year[:semester].map! do |semester|
        semester[:year_begin], semester[:year_end] = year[:edu_year_name].split(" - ")
        semester[:kind] = semester_name_to_num(semester[:semester_name])
        semester[:disc_name] = Array.wrap(semester[:disc_name])
        semester.except(:semester_name)
      end
      year[:semester]
    }.flatten
  end

  def self.semester_name_to_num(name)
    {
      "I полугодие" => :fall,
      "II полугодие" => :spring
    }.fetch(name, :fall)
  end
end
