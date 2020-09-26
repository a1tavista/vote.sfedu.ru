module OneCApi
  module Constants
    GRADE_NUM_MAPPING = {
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
      "Одиннадцатый" => 11,
    }.freeze

    GRADUATING_LEVEL_MAPPING = {
      "61" => :applied_bachelor,
      "62" => :academic_bachelor,
      "65" => :specialist,
      "68" => :master,
      "72" => :postgraduate
    }.freeze

    TIME_TYPE_MAPPING = {
      "Дистанционная" => :distant,
      "Очная" => :fulltime,
      "Очно-заочная" => :parttime,
      "Заочная" => :extramural
    }.freeze

    SEMESTER_MAPPING = {
      "I полугодие" => :fall,
      "II полугодие" => :spring
    }.freeze
  end
end
