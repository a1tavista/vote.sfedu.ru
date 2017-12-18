class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    can %i(index prepare choose), Teacher
    can %i(show respond), Teacher do |teacher|
      user.kind.available_teachers(Stage.current).include?(teacher)
    end
  end
end
