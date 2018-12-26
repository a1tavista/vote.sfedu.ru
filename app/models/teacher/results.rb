class Teacher::Results
  attr_reader :stage
  attr_reader :teacher
  attr_reader :participations_count

  def initialize(teacher, stage, calc_relaxed: true, strict: false, safe: true)
    @stage = stage
    @teacher = teacher

    @calc_relaxed = calc_relaxed
    @strict = strict
    @safe = safe

    @questions = stage.questions.select(:id, :text).index_by(&:id)
    @participations_count = teacher.participations.where(stage: stage).count
    @answers = teacher.answers.select(:id, :question_id, :ratings).where(stage: stage).order('id ASC')
  end

  def full_info
    {
      rating_of_questions: rating_of_questions,
      participations_count: @participations_count,
      mean_rating_of_questions: mean_rating_of_questions,
      scaled_rating_of_questions: scaled_rating_of_questions
    }
  end

  def rating_of_questions
    @answers.map do |answer|
      rating = calculate_question_rating_for(answer.ratings.dup)
      relaxed_rating = calculate_relaxed_question_rating_for(answer.ratings.dup)

      {
        question: @questions[answer.question_id],

        # Рейтинг до удаления значений-выбросов
        rating: rating,

        # Рейтинг после удаления значений-выбросов
        relaxed_rating: relaxed_rating || 0,

        # Рейтинг после проверки на преодоление нижней границы участников
        total_rating: respondents_bound_check(answer, rating),

        # Очищенный рейтинг после проверки на преодоление нижней границы участников
        total_relaxed_rating: respondents_bound_check(answer, relaxed_rating || rating),
      }
    end
  end

  def mean_rating_of_questions(calc_by: :total_rating)
    return 'N/A' if @stage.current? && @safe

    questions_ratings ||= rating_of_questions
    return 0.0 if questions_ratings.count.zero?

    questions_sum = questions_ratings.map { |q| q[calc_by] }.sum
    questions_count = questions_ratings.count.to_f

    questions_sum / questions_count
  end

  def scaled_rating_of_questions(calc_by: :total_rating)
    return 'N/A' if @stage.current? && @safe

    rating = mean_rating_of_questions
    score = @stage.converted_scale_ladder.index do |r|
      r.include?(rating)
    end
    (score || -1) + 1
  end

  private

  def need_relaxed_rating?
    @calc_relaxed
  end

  # Подсчитывает и возвращает среднюю оценку по указанному критерию.
  #
  # На вход методу подается массив чисел с количеством участников, оценивших преподавателя на
  # оценку по критерию, равную index_of_array + 1.
  #
  # Например, преподавателя оценивали по критерию по шкале от 1 до 5,
  # тогда `[3, 0, 0, 7, 2]` будет означать, что 3 человека оценили на единицу,
  # 7 человек оценили на четверку, 2 на пятерку.
  #
  # @param [Array] answer_ratings - массив, содержащий количество баллов по критериям
  # @return [Float] question_rating - средняя оценка по указанному критерию
  def calculate_question_rating_for(answer_ratings)
    # 1. Получаем число участников, оценивших преподавателя, как сумму значений массива, приведенного выше.
    respondents_count = answer_ratings.sum
    return 0 if respondents_count.zero?

    # 2. Получаем среднюю оценку, умножая число участинков на значение шкалы
    scale = Array.new(answer_ratings.length) { |idx| idx + 1 } # Массив от 1 до ratings.length
    ratings_sum = answer_ratings.zip(scale).map { |idx, value| idx * value }.sum
    ratings_sum / respondents_count.to_f
  end

  def calculate_relaxed_question_rating_for(answer_ratings)
    return nil unless need_relaxed_rating?
    respondents_count = answer_ratings.sum
    lower_truncation, upper_truncation = calculate_rating_bounds(respondents_count)

    i = 0
    j = answer_ratings.length - 1

    # Подрезаем значения снизу массива.
    # Например, необходимо убрать 4 самых низких оценки из массива [0, 3, 5, 4, 1], тогда
    # результатом будет [0, 0, 4, 4, 1].
    while lower_truncation > 0 && i < answer_ratings.length
      if lower_truncation >= answer_ratings[i]
        lower_truncation -= answer_ratings[i]
        answer_ratings[i] = 0
      else
        answer_ratings[i] = answer_ratings[i] - lower_truncation
        lower_truncation = 0
      end
      i += 1
    end

    # Подрезаем значения сверху массива.
    # Например, необходимо убрать 2 самых верхних оценки из массива [0, 0, 4, 4, 1], тогда
    # результатом будет [0, 0, 4, 3, 0].
    while upper_truncation > 0 && j >= 0
      if upper_truncation >= answer_ratings[j]
        upper_truncation -= answer_ratings[j]
        answer_ratings[j] = 0
      else
        answer_ratings[j] -= upper_truncation
        upper_truncation = 0
      end
      j -= 1
    end

    calculate_question_rating_for(answer_ratings)
  end

  def respondents_bound_check(answer, rating)
    respondents_count = answer.ratings.sum
    return 0 if respondents_count < @stage.lower_participants_limit

    rating
  end

  # Возвращает число самых высоких и самых низких оценок, которые нужно убрать из выборки
  def calculate_rating_bounds(respondents_count)
    lower_truncation = (respondents_count * (@stage.lower_truncation_percent / 100.0)).round
    upper_truncation = (respondents_count * (@stage.upper_truncation_percent / 100.0)).round
    lower_truncation = 1 if lower_truncation.zero?
    upper_truncation = 1 if upper_truncation.zero?

    [lower_truncation, upper_truncation]
  end
end
