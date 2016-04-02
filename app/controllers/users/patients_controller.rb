class Users::PatientsController < ApplicationController
  before_filter :verify_auth_user
  def show
    @user = User.find(params[:id])
    @upcoming_bookings = @user.appointments.upcoming_appointments
    @past_appointments = @user.appointments.past_appointments
    @doctors = DoctorUser.all
    params[:header_template] = 'header_darked'
  end

  def edit
    @user = PatientUser.find(params[:id])
    params[:header_template] = 'header_darked'
  end

  def update
    if auth_user.update_attributes(patient_params)
      redirect_to :back
    else
      render 'show'
    end
  end

  def disconnect_identity
    @user = PatientUser.find(params[:id])
    if params[:provider] == 'google_oauth2'
      result = @user.disconnect_identity(session[:token], params[:provider])
      if result
        flash[:notice] = "Your account has been successfully disconnected from #{omniauth_providers[params[:provider]]}."
      else
        flash[:error] = "An error occured disconnecting from #{omniauth_providers[params[:provider]]}."
      end
    end
    redirect_to action: 'edit'
  end

  private
  def patient_params
    params.require(:patient_user).permit(:email, :first_name, :last_name, :birthdate, :avatar, :address, :city, :state, :zipcode, :country)
  end
end
