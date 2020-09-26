class PagesController < ApplicationController
  def index
    @stage = Stage.current
    @stages = Stage.all.order("starts_at DESC")
    @polls = Poll.all.order(starts_at: :desc)
  end

  def faq
  end
end
