class Ability
  include CanCan::Ability


  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities


    user ||= User.new # guest user
    if user.role? :super_admin
      can :manage, :all
    else
      if user.role? :moderator
        can :manage, Post
        #can :manage, Comment
      else
        if user.role? :post
          can :create, Post
          can :new, Post
          can :manage, Post, :user_id => user.id
        end
      end
      can :read, :all
      can :new, User
      can :create, User
      #can :create, Comment, !user.new_record?
    end
  end
end

