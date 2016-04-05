class AppointmentsController < ApplicationController
  respond_to :json, :html

  def create
    @app = BookedHour.new(appointments_params)
    if @app.save
      render json: {data: {appointment: @app, status: :success}}
    else
      render json: { staus: 400, message: @app.errors }
    end
  end

  def update
    @app = BookedHour.find(params[:id])
    @app.from = appointments_params[:from] unless appointments_params[:from].nil?
    @app.to = appointments_params[:to] unless appointments_params[:to].nil?
    @app.title = appointments_params[:title] unless appointments_params[:title].nil?
    binding.pry
    if @app.save
      render json: {data: {appointment: @app}, status: :success}
    else
      render json: {data: {errors: @app.errors}, status: :fail}
    end
  end

  def destroy
    @app = BookedHour.find(params[:id])
    if patient_signed_in? && @app.destroy
      render json: {data: {appointment: @app}, status: :success}
    else
      render json: {status: :fail}
    end
  end

  def approve
    if doctor_signed_in?
      @app = BookedHour.find(params[:id])
      @app.approved!
      render json: {data: {appointment: @app}, status: :success}
    else
      render json: {status: :fail}
    end
  end

  def cancel
    if doctor_signed_in?
      @app = BookedHour.find(params[:id])
      @app.canceled!
      render json: {data: {appointment: @app}, status: :success}
    else
      render json: {status: :fail}
    end
  end

  private
  def appointments_params
    params.require(:booked_hour).permit(:id, :from, :to, :doctor_user_id, :patient_user_id, :title)
  end
end
