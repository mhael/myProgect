class ApplicationController < ActionController::Base
  require 'open-uri'
  
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  rescue_from OpenURI::HTTPError do |exception|
    flash[:error] = "Apeha.ru"
    redirect_to new_user_registration_path
  end
end

