class Teacher < ApplicationRecord
  has_many :students_teachers_relations, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :participations, dependent: :destroy

  enum kind: %i(common physical_education foreign_language)

  def evaluate_by(student, stage, answers)
    ActiveRecord::Base.transaction do
      Participation.create!(stage: stage, student: student, teacher: self)
      answers.uniq! { |a| a[:question_id] }
      ids = answers.map { |a| a[:question_id] }
      unless ids.sort == stage.questions.pluck(:id).sort
        raise 'Answer questions and stage questions are different'
      end
      answers.each do |a|
        Answer.save_rating_for!(stage, self, Question.find(a[:question_id]), a[:rate])
      end
    end
  end

  def questions_rating_for(stage)
    answers_list = answers.where(stage: stage, teacher: self)
    answers_list.map do |a|
      {
        question: a.question,
        rating: a.question_rating,
        scaled_rating: a.scaled_question_rating,
      }
    end
  end

  def total_rating_for(stage, type: :scaled_rating)
    questions_answers = questions_rating_for(stage)
    return 0.0 if questions_answers.count.zero?
    questions_answers.map { |q| q[type] }.sum / questions_answers.count.to_f
  end

  def scaled_rating_for(stage, type: :scaled_rating)
    score = stage.scale_ladder.index do |r|
      r.include?(total_rating_for(stage, type: type))
    end
    (score || -1) + 1
  end
end
