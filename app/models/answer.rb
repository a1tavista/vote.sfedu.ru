class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :stage
  belongs_to :teacher

  # Валидация того, что вопрос присутствует в указанной стадии
  # Валидация того, что ответ меньше, чем max_rating указанной стадии
  # Валидация того, что стадия в процессе (нельзя менять ответы предыдущей стадии)

  before_create :initialize_ratings!

  def self.save_rating_for!(stage, teacher, question, rate)
    answer = where(stage: stage, teacher: teacher, question: question).first_or_create!
    answer.ratings[rate - 1] += 1
    answer.save
  end

  def question_rating(ratings_array: nil)
    idx = 0
    ratings_array ||= ratings

    participations = ratings_array.sum
    return 0 if participations.zero?

    ratings_array.map do |value|
      idx += 1
      value * idx
    end.sum / participations.to_f
  end

  def scaled_question_rating
    participations = ratings.sum
    return 0 if participations < stage.lower_participants_limit

    handled_ratings = ratings

    lower_truncation = (participations * (stage.lower_truncation_percent / 100.0)).round
    upper_truncation = (participations * (stage.upper_truncation_percent / 100.0)).round

    # TODO: Алгоритм подрезки оценок

    question_rating(ratings_array: handled_ratings)
  end

  private

  def initialize_ratings!
    self.ratings = [0] * question.max_rating
  end
end
