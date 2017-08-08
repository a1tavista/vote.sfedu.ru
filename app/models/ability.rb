class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can %i(read respond), Teacher do |teacher|
      user.kind.available_teachers(Stage.current).include?(teacher)
    end
  end
end
