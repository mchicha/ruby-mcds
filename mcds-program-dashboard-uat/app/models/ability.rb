class Ability
  include CanCan::Ability

  def initialize(user)
    if user.tukaiz_super_admin? && Redis.current.get("#{user.id}_role_stub").present?
      user.role = Redis.current.get("#{user.id}_role_stub")
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    if user.tukaiz_super_admin?
      can :manage, :all
      cannot :manage, Message
      message_manager_check(user)
    end

    if user.admin?
      can :manage, Alert
      can :manage, AlertGeography
      can :manage, Moment
      can :manage, GeographyMoment
      can :manage, Program
      can :manage, GeographyProgram
      can :manage, ColorBlock
      can :manage, Agency
      can :manage, Schematic
      can :create, GeographiesSchematic
      can :manage, Document
      cannot :admin_manage, Document
      can :manage, Element
      message_manager_check(user)
      can :manage, Event
      can :manage, Calendar
      can :read, User
      can :upload, :multiple_assets
      can :access, :dam
    end

    if user.inputter?
      can :create, Program
      can :read, Program
      can :manage, Program, geographies: {users: {id: user.id}}
      can :read, Alert
      can :create, Alert
      can :manage, Alert, geographies: {users: {id: user.id}}
      can :manage, AlertGeography, geography: {users: {id: user.id}}
      can :read, Moment
      can :create, Moment
      can :manage, Moment, geographies: {users: {id: user.id}}
      can :manage, GeographyMoment, geography: {users: {id: user.id}}
      can :manage, GeographyProgram, geography: {users: {id: user.id}}
      can :read, ColorBlock
      can :read, Agency
      can :read, Schematic, status: 'published'
      can :create, Schematic
      can :manage, Schematic, geographies: {users: {id: user.id}}
      can :create, GeographiesSchematic, geography: {users: {id: user.id}}
      can :manage, Document
      cannot :admin_manage, Document
      can :manage, Element
      can :manage, Calendar
      can :read, User

      message_manager_check(user)
      can_generate_reports
      can_access_dam
    end

    if user.leadership?
      can :read, Program
      can :manage, Program
      cannot :create, Program
      cannot :update, Program
      cannot :edit, Program
      cannot :destroy, Program
      can :read, Schematic, status: 'published'
      message_manager_check(user)
      can :read, Moment
      can :manage, Calendar
      can :read, Element
      can_generate_reports
    end

    if user.us_read_only?
      can :read, Program
      can :manage, Program
      cannot :create, Program
      cannot :update, Program
      cannot :edit,   Program
      cannot :destroy, Program
      can :read, Schematic, status: 'published'
      message_manager_check(user)

      can :read, Moment
      can :read, Element
    end



    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user.reload

    if user.tukaiz_super_admin?
      can :manage, User
    end
  end

  def message_manager_check(user)
    can :manage, Message do |message|
      message.new_record? || Message.viewable_messages(user).include?(message)
    end
  end

  def can_access_dam
    can :view, :access_dam
  end

  def can_generate_reports
    can :view, :generate_reports
  end
end
