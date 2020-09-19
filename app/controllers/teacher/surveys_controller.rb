class Teacher::SurveysController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @surveys = @surveys.order(created_at: :desc)
  end

  def show
  end

  def new
    @survey = SurveyCloner.call(Survey.find_by_id(params[:source_id])) if params[:source_id].present?
  end

  def create
    @survey = Survey.create(survey_params.merge(user: current_user))
    if @survey.persisted?
      redirect_to survey_path(@survey.passcode)
    else
      flash[:error] = @survey.errors.full_messages
      render action: :new
    end
  end

  def edit
  end

  def update
    if @survey.update(survey_params.merge(user: current_user))
      redirect_to survey_path(@survey.passcode)
    else
      render action: :new
    end
  end

  private

  def survey_params
    params_list = [
      :id,
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
