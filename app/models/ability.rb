class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.doctor?
      can :manage, User, id: user.id
      can :show, User
      can :manage, Appointment, doctor_user_id: user.id
    elsif user.patient?
      can :manage, User, id: user.id
      can :show, User
      # can [:read, :create], Appointment, patient_user_id: user.id
      can :cancel, Appointment do |app|
        app.patient_user_id == user.id && !app.starting_in_3_hours?
      end
      can :read, Appointment, patient_user_id: user.id
    end
  end
end
