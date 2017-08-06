class PagesController < ApplicationController
  def index
    @stage = Stage.current
    @stages = Stage.all
  end

  def faq

  end
end
