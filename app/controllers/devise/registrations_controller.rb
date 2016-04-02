class Devise::RegistrationsController < Devise::SessionsController

  def new
    if resource_name == :patient_user
      @user = PatientUser.new
    else
      @user = DoctorUser.new
      # @user.open_hours.build
      @user.build_default_info
    end
    params[:hide_signup] = true
  end

  def create
    if User.find_by(email: params[resource_name][:email]).nil?
      klass = resource_name.to_s.classify.constantize
      @user = klass.new(user_params)
      # binding.pry
      if @user.save
        return redirect_to account_url
      else
        redirect_to :back
      end
    else
      flash[:error] = "User already exists with the email."
      redirect_to :back
    end
  end

  protected

  def user_params
    resource_name == :patient_user ? patient_params : doctor_params
  end

  def doctor_params
    params.require(:doctor_user).permit(
      :type, :email, :first_name, :last_name, :password, :password_confirmation,
      :address, :city, :state, :zipcode, :country,
      :avatar, :bizname, :phone,
      doctor_info_attributes: [ :website, :speciality, :speciality_id, :bio, :house_calls, :hours_from, :hours_to, days: [] ],
      # open_hours_attributes: [ :title, :from, :to ]
    )
  end

  def patient_params
    params.require(:patient_user).permit(:email, :type, :first_name, :last_name, :password, :password_confirmation, :address, :city, :state, :zipcode, :country,)
  end
end
