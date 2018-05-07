class Survey < ApplicationRecord
  has_many :questions, class_name: 'SurveyQuestion', dependent: :destroy
  has_many :options, class_name: 'SurveyOption', through: :questions
  has_many :answers, class_name: 'SurveyAnswer', dependent: :destroy
  has_many :users, -> { distinct }, through: :answers
  has_many :sharings, class_name: 'SurveySharing', dependent: :destroy

  validates :title, presence: true
  validates :passcode, presence: true

  accepts_nested_attributes_for :questions, reject_if: :all_blank

  belongs_to :user

  def new_answer!(user_id, question_id, option_id: nil, option_text: '')
    question = questions.find_by(id: question_id)

    if option_id.present? && option_id.is_a?(Numeric)
      option = question.options.find(option_id)
    else
      option_query = question.options.where(text: option_text)
      option = if question.free_answer
                 option_query.first_or_create! do |opt|
                   opt.custom = true
                 end
               else
                 option_query.first!
               end
    end

    SurveyAnswer.create!(survey: self, survey_question: question, survey_option: option, user_id: user_id)
  end

  def answered_for?(user_id)
    answers.where(user_id: user_id).any?
  end
end
