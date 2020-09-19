class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.teacher?
      can %i[read create update], Survey
    end

    if user.student?
      can %i[index refresh prepare choose], Teacher
      can %i[show respond], Teacher do |teacher|
        user.kind.available_teachers(Stage.current).include?(teacher)
      end
    end
  end
end
