class AdminAbility
  include CanCan::Ability

  def initialize(_user)
    return unless _user.admin?

    can :manage, :all
    # Define abilities here. More info: https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities
  end
end
