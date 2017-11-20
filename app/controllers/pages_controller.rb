class PagesController < ApplicationController
  def index
    @stage = Stage.current
    @stages = Stage.all.order('starts_at DESC')
  end

  def faq

  end
end
