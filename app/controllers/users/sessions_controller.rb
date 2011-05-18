class Users::SessionsController < Devise::SessionsController
  after_filter 'current_user.get_prof'.to_sym, :only => :create
end
