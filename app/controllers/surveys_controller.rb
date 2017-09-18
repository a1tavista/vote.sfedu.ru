class SurveysController < ApplicationController
  before_action :authenticate_user!
  load_resource find_by: :passcode

  def show; end
end
