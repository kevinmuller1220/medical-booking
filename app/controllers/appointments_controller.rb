class AppointmentsController < ApplicationController
  respond_to :json, :html

  def index
    @appointments = Appointment.all
    render json: @appointments
  end

  def create
    @doctor = User.find(params[:users][:id])
    @app = auth_user.appointments.build(appointment_date: DateTime.strptime(params[:appointments][:appointment_date], '%m/%d/%Y %I:%M %p'), doctor_user_id: params[:users][:id], reason: appointments_params[:reason], subject: appointments_params[:subject] )
    if @app.save
      render json: {data: {appointment: @app, status: :ok}}
    else
      render json: { staus: 400, message: @app.errors }
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
    render json: @appointment
  end

  def update
    @app = Appointment.find(params[:id])
    @app.appointment_date = DateTime.strptime(params[:appointments][:appointment_date], '%m/%d/%Y %I:%M %P')
    @app.reason = appointments_params[:reason] unless appointments_params[:reason].nil?
    @app.subject = appointments_params[:subject] unless appointments_params[:subject].nil?
    binding.pry
    if @app.save
      render json: {data: {appointment: @app, status: :ok}}
    else
      render json: {data: {erros: @app.errors, status: 404}}
    end
  end

  def import_to_google_calendar
    @app = Appointment.find(params[:id])
    omniauth = request.env['omniauth.auth']
    @gc = GoogleCalendar.new(session[:token])
    @gc.create_event(@app)
    redirect_to :back
  end

  def re_schedule
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    if @appointment.destroy
      render json: { status: :ok }
    else
      render json: { status: 400, message: "Not deleted" }
    end
  end

  private
  def appointments_params
    params.require(:appointments).permit(:id, :appointment_date, :patient_user_id, :doctor_user_id, :reason, :subject)
  end
end
