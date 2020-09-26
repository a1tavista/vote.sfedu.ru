module Api
  class SurveysController < API::BaseController
    before_action :authenticate_user!

    def questions
      @questions = Survey.find(params[:id]).questions
    end

    def answers
      @survey = Survey.find(params[:id])

      ActiveRecord::Base.transaction do
        params[:answers].each do |question_id, answer|
          answer[:options].each do |option_id|
            @survey.new_answer!(current_user.id, question_id, option_id: option_id)
          end
          @survey.new_answer!(current_user.id, question_id, option_text: answer[:text]) if answer[:text].present?
        end
      end
    end
  end
end
