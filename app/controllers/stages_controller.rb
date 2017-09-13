class StagesController < ApplicationController
  def show
    @stage = Stage.find(params[:id])
  end
end
