class StagesController < ApplicationController
  def show
    @stage = Stage.find_by(id: params[:id])
  end

  def statistics
    @stage = Stage.find_by(id: params[:id])
  end
end
