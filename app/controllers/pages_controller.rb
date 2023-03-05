class PagesController < ApplicationController
  def index
    @stage = Stage.current
    @all_activities = (Stage.all + Poll.not_archived).sort_by(&:starts_at).reverse
  end

  def faq
  end
end
