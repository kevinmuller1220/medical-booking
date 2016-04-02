class Users::OmniauthCallbacksController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, only: :create

  prepend_before_filter { request.env["devise.skip_timeout"] = true }

  def passthru
    render status: 404, text: "Not found. Authentication passthru."
  end

  def google_oauth2
    puts 'here-first'
    puts request.env["omniauth.auth"]
    auth = request.env['omniauth.auth']
    @identity = Identity.find_with_omniauth(auth)
    if @identity.nil?
      # If no identity was found, create a brand new one here
      @identity = Identity.create_with_omniauth(auth)
    end
    if signed_in?
      if @identity.user == auth_user
        redirect_to account_url
        redirect_to account_url, notice: "Already linked that account!"
      else
        # The identity is not associated with the current_user so lets
        # associate the identity
        @identity.user = auth_user
        @identity.save
        redirect_to account_url, notice: "Successfully linked that account!"
      end
    else
      if @identity.user.present?
        # The identity we found had a user associated with it so let's
        # just log them in here
        sign_in(:user, @identity.user)
        redirect_to account_url, notice: "Signed in!"
      else
        # No user associated with the identity so we need to create a new one
        o_params = request.env['omniauth.params']
        if o_params['type'].present? && o_params['type'] == 'DoctorUser'
          @user = DoctorUser.create_with_omniauth(auth)
        else
          @user = PatientUser.create_with_omniauth(auth)
        end
        @identity.user = @user
        @identity.save!

        sign_in(:user, @user)
        if @user.persisted?
          flash[:notice] = "Welcome #{@user.full_name}, please update your profile."
          redirect_to account_url
        else
          session["devise.user_attributes"] = @user.attributes
          redirect_to new_patient_user_registration_url
        end
      end
    end
    @token = auth["credentials"]["token"]
    session[:token] = @token
  end

  def facebook
  end

  def failure
    super
  end
end
