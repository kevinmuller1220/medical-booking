class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  # before_filter :notify_user
  include ApplicationHelper

  before_action :initialize_omniauth_state

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to account_url, :alert => exception.message
  end

  helper_method :account_url

  def account_url
    return new_user_session_url unless signed_in?
    account_path
  end

  def verify_auth_user
    if signed_in?
      if !auth_user.is_a?(AdminUser) && auth_user.id.to_s != params[:id].to_s
        redirect_to root_path
      end
    else
      authenticate_patient_user!
    end
  end

  protected

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  private

  def notify_user
    if signed_in?
      @notifications = auth_user.appointments.starting_next_hour
    end
  end
end
