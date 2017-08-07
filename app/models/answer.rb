class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :stage
  belongs_to :teacher

  before_create :initialize_ratings!

  def self.save_rating_for(stage, teacher, question, rate)
    answer = where(stage: stage, teacher: teacher, question: question).first_or_create
    begin
      answer.ratings[rate - 1] += 1
      answer.save
    rescue NoMethodError => e
      puts e
    end
  end

  def question_rating
    idx = 0
    ratings.map do |value|
      idx += 1
      value * idx
    end.sum
  end

  private

  def initialize_ratings!
    self.ratings = [0] * question.max_rating
  end
end
