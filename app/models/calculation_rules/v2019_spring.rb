module CalculationRules
  class V2019Spring
    extend Dry::Initializer

    param :teacher
    param :stage

    def call
      mean_rating = mean_rating_of_stage(calc_by: stage.with_truncation ? :relaxed_rating : :rating)

      {
        rating_by_questions: rating_by_questions,
        participations_count: participations_count,
        mean_rating_of_stage: mean_rating,
        final_rating_of_stage: stage.with_scale ? scale_rating(mean_rating: mean_rating) : mean_rating
      }
    end

    def self.converted_scale_ladder
      stage.scale_ladder.map do |range|
        range_begin, range_end = range.split("...")
        exclude_end = !range_end.nil?
        range_begin, range_end = range.split("..") if range_end.nil?
        Range.new(range_begin.to_f, range_end.to_f, exclude_end)
      end
    end

    def self.recalculate_scale_ladder!
      step = (stage.scale_max - stage.scale_min) / stage.scale_max.to_f
      current = stage.scale_min.to_f

      ladder = []

      while (current + step) < stage.scale_max
        ladder.push((current...(current + step).round(4)))
        current = (current + step).round(4)
      end

      ladder.push((current..(current + step)))

      ladder
    end

    private

    def questions
      @questions ||= stage.questions.select(:id, :text).index_by(&:id)
    end

    def answers
      @answers ||= teacher.answers.select(:id, :question_id, :ratings).where(stage: stage).order("id ASC")
    end

    def participations_count
      @participations_count ||= teacher.participations.where(stage: stage).count
    end

    # Рейтинг преподавателя по каждому критерию оценивания.
    # Включает в себя значения:
    #   * question – вопрос, по которому выставлен рейтинг
    #   * rating_before_limitation_check – рейтинг по критерию без модификаций (среднее арифмитическое)
    #   * rating – рейтинг по критерию с учетом минимального порога респондентов
    def rating_by_questions
      @rating_by_questions = answers.map { |answer|
        rating = calculate_question_rating_for(answer.ratings.dup)

        {
          question: questions[answer.question_id],
          rating_before_limitation_check: rating,
          rating: respondents_limitation_check(answer, rating)
        }.merge(relaxed_ratings_for_question(answer))
      }
    end

    # Рейтинг преподавателя по каждому критерию оценивания после нормализации оценок.
    # Включает в себя значения:
    #   * relaxed_rating_before_limitation_check – рейтинг по критерию после удаления значений-выбросов
    #   * relaxed_rating – рейтинг по критерию с учетом минимального порога респондентов после удаления значений-выбросов
    #
    # Не используется в расчетах, если в стадии не предусмотрена нормализация оценок.
    def relaxed_ratings_for_question(answer)
      return {} unless stage.with_truncation?

      relaxed_answer_ratings = relax_answers_of_participants(answer.ratings.dup)
      relaxed_rating = calculate_question_rating_for(relaxed_answer_ratings)

      {
        relaxed_rating_before_limitation_check: relaxed_rating,
        relaxed_rating: respondents_limitation_check(answer, relaxed_rating)
      }
    end

    def mean_rating_of_stage(calc_by:)
      questions_ratings ||= (@rating_by_questions || rating_by_questions)
      return 0.0 if questions_ratings.count.zero?

      questions_sum = questions_ratings.map { |question_rating| question_rating[calc_by] }.sum
      questions_count = questions_ratings.count.to_f

      questions_sum / questions_count
    end

    def scale_rating(mean_rating:)
      score = stage.converted_scale_ladder.index { |range| range.include?(mean_rating) }
      (score || -1) + 1
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
      return 0.0 if respondents_count.zero?

      # 2. Получаем среднюю оценку, умножая число участинков на значение шкалы
      scale = Array.new(answer_ratings.length) { |rate| rate + 1 } # Массив от 1 до ratings.length
      ratings_sum = answer_ratings.zip(scale).map { |rate, count| rate * count }.sum
      ratings_sum / respondents_count.to_f
    end

    # Убирает значения с хвостов диапазона оценок для нормализации выборки.
    # Используется для того, чтобы исключить некоторый процент
    # "слишком положительных" и "слишком отрицательных" оценок от респондентов.
    def relax_answers_of_participants(answer_ratings)
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

      answer_ratings
    end

    private

    def respondents_limitation_check(answer, rating)
      return rating if stage.lower_participants_limit.nil?

      respondents_count = answer.ratings.sum
      return 0 if respondents_count < stage.lower_participants_limit

      rating
    end

    # Возвращает число самых высоких и самых низких оценок, которые нужно убрать из выборки
    def calculate_rating_bounds(respondents_count)
      return [0, 0] unless stage.with_truncation?

      lower_truncation = (respondents_count * (stage.lower_truncation_percent / 100.0)).round
      upper_truncation = (respondents_count * (stage.upper_truncation_percent / 100.0)).round
      lower_truncation = 1 if lower_truncation.zero?
      upper_truncation = 1 if upper_truncation.zero?

      [lower_truncation, upper_truncation]
    end
  end
end
