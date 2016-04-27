class ReviewsController < ApplicationController

  before_filter :check_review_exists, only: [:new, :create]

  def new
    @review = Review.new
    params[:header_template] = 'header_darked'
  end

  def create
    @review = Review.new(reviews_params)
    @review.save!
    flash[:notice] = 'Your feedback has been published successfully.'
    redirect_to patient_path(@appointment.patient_user_id)
  end

  def check_review_exists
    @appointment = BookedHour.find(params[:appointment_id])
    if @appointment.review.present?
      flash[:error] = 'You have already left a feedback for this appointment.'
      redirect_to patient_path(@appointment.patient_user_id)
    end
  end

  private
  def reviews_params
    params[:review][:appointment_id] = params[:appointment_id]
    params.require(:review).permit(:appointment_id, :avg_score, :feedback)
  end
end
