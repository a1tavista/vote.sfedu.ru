class Teacher::SurveysController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index; end

  def show; end

  def new; end

  def create
    @survey = Survey.create(survey_params.merge(user: current_user))
    if @survey.persisted?
      redirect_to survey_path(@survey.passcode)
    else
      render action: :new
    end
  end

  private

  def survey_params
    params_list = [
      :title,
      :passcode,
      :active_until,
      questions_attributes: [
        :id,
        :text,
        :required,
        :multichoice,
        :free_answer,
        options_attributes: [
          :id,
          :text
        ]
      ]
    ]

    params.require(:survey).permit(params_list)
  end
end
