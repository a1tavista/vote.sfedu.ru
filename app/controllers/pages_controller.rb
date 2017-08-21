class PagesController < ApplicationController
  def index
    @stage = Stage.current
    @stages = Stage.all.order('created_at DESC')
  end

  def faq

  end
end
