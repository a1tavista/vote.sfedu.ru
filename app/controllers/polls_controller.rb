class PollsController < ApplicationController
  def show
    @poll = Poll.find_by(id: params[:id])
  end
end
