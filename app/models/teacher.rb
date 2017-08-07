class Teacher < ApplicationRecord
  has_many :students_teachers_relations, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :participations, dependent: :destroy

  def questions_rating_for(stage)
    participants = participations.where(stage: stage, teacher: self).count
    answers_list = answers.where(stage: stage, teacher: self)
    answers_list.map do |a|
      {
        question: a.question,
        rating: a.question_rating / 9.0,
        scaled_rating: a.scaled_question_rating(participants) / 9.0
        # rating: a.question_rating / participants.to_f,
      }
    end
  end

  def total_rating_for(stage, rating_type: :scaled_rating)
    questions_answers = questions_rating_for(stage)
    questions_answers.map { |q| q[rating_type] }.sum / questions_answers.count.to_f
  end

  def scaled_rating_for(stage)
    score = (stage.scale_ladder.index { |r| r.include?(total_rating_for(stage)) } || -1)
    score + 1
  end
end
