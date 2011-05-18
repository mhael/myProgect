class Users::RegistrationsController < Devise::RegistrationsController
  # before_filter :check_permissions, :only => [:cancel]
  #skip_before_filter :require_no_authentication
  #load_and_authorize_resource
  #include UsersHelper
  
  def new
    session[:user_params] ||= {}
    build_resource(session[:user_params])
    session[:user_step] = resource.current_step
    render_with_scope :new
  end

  def create
    session[:user_params].deep_merge!(params[:user]) if params[:user]
    build_resource(session[:user_params])
    resource.current_step = session[:user_step]
    if params[:back_button]
      resource.previous_step
      session[:user_step] = resource.current_step
    else
      if resource.valid?
        #get_username_from_link
        #session[:user_params].deep_merge!(params[:user]) if params[:user]
        #build_resource(session[:user_params])
        if resource.last_step?
          resource.username = resource.get_user_name_from_link(resource.link)
          resource.save if resource.all_valid?
          resource.get_prof
        else
          resource.username = resource.get_user_name_from_link(resource.link)
          resource.next_step unless params[:back_button]
        end
        session[:user_step] = resource.current_step
      end
    end
    if resource.new_record?
      clean_up_passwords(resource)
      #      params[:user][:username]=resource.attributes[:username]
      #     session[:user_params].deep_merge!(params[:user]) if params[:user]
      render_with_scope :new
    else
      session[:user_step] = session[:user_params] = nil
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    end
  end
end

