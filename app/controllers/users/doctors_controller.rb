require 'google/apis/calendar_v3'

class Users::DoctorsController < ApplicationController
  before_filter :search_params, only: [:index]
  before_filter :verify_auth_user, except: [:index, :show]
  def index
    @doctors = DoctorUser.all
    filters = search_params.reject{|k, v| v.blank? || k == 'name_order' || k == 'distance_order' }
    filters.each do |key, value|
      if key == "appointment_date"
        value = Date.strptime(value, "%m/%d/%Y").strftime("%w").downcase
      end
      @doctors = @doctors.send("by_#{key}", value)
    end

    if search_params[:name_order].present?
      @doctors = @doctors.send("by_name_order", search_params[:name_order])
    end

    if search_params[:distance_order].present?
      longitude = auth_user ? auth_user.longitude : 0
      latitude = auth_user ? auth_user.latitude : 0
      @doctors = @doctors.send("by_distance_order", search_params[:distance_order], longitude, latitude)
    end

    prep_search_params(search_params)

  end

  def show
    @user = DoctorUser.find(params[:id])
    @hidden_days = ((1..7).to_a - @user.days.map(&:to_i)).to_s
    params[:header_template] = 'header_darked'

    if session[:token].present?
      client = Signet::OAuth2::Client.new(access_token: session[:token])
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
      limit = 1000
      now = Time.now.iso8601
      page_token = nil
      @calendar_list = service.list_events(
        'primary',
        max_results: [limit, 100].min,
        single_events: true,
        order_by: 'startTime',
        time_min: now,
        time_max: (Time.now + 7.days).iso8601,
        page_token: page_token,
        fields: 'items(id,summary,start,end),next_page_token'
      )
    end
  end

  def edit
    @user = DoctorUser.find(params[:id])
    params[:header_template] = 'header_darked'
  end

  def update
    @user = DoctorUser.find(params[:id])
    if @user.update_attributes(doctor_params)
      redirect_to :back
    else
      render 'settings'
    end
  end

  def disconnect_identity
    @user = DoctorUser.find(params[:id])
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
  def search_params
    params.permit(:zipcode, :city, :state, :speciality, :speciality_id,
      :appointment_date, :appointment_period, :appointment_time,
      :name_order, :distance_order)
  end

  def doctor_params
    params.require(:doctor_user).permit(
      :email, :first_name, :last_name, :password, :password_confirmation,
      :address, :city, :state, :zipcode, :country,
      :avatar, :bizname, :phone,
      doctor_info_attributes: [ :id, :website, :speciality, :speciality_id, :bio, :house_calls, :hours_from, :hours_to, days: [] ],
      # open_hours_attributes: [ :id, :title, :from, :to ]
      booked_hours_attributes: [ :id, :title, :from, :to ]
    )
  end

  def prep_search_params(search_params)
    @params_name_order_asc = search_params.dup
    @params_name_order_desc = search_params.dup
    @params_distance_order_asc = search_params.dup
    @params_distance_order_desc = search_params.dup

    @params_name_order_asc[:name_order] = 'asc'
    @params_distance_order_asc[:distance_order] = 'asc'
    @params_name_order_desc[:name_order] = 'desc'
    @params_distance_order_desc[:distance_order] = 'desc'
  end
end
