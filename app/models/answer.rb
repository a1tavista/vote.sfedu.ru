class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :stage
  belongs_to :teacher

  # Валидация того, что вопрос присутствует в указанной стадии
  # Валидация того, что ответ меньше, чем max_rating указанной стадии
  # Валидация того, что стадия в процессе (нельзя менять ответы предыдущей стадии)

  before_create :initialize_ratings!

  private

  def initialize_ratings!
    self.ratings = [0] * question.max_rating
  end
end
