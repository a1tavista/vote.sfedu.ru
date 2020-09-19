class SurveysController < ApplicationController
  before_action :authenticate_user!
  load_resource find_by: :passcode

  def show
  end

  def results
    @breakdown = Survey::Results.new(@survey).breakdown
  end

  def respondents
    @respondents = @survey.users
  end
end
