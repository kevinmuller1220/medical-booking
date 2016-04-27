class Review < ActiveRecord::Base
  belongs_to :booked_hour, class_name: 'BookedHour', foreign_key: "appointment_id"

  after_create :update_doctor_reviews

  def update_doctor_reviews
    doctor = self.booked_hour.doctor_user
    doctor_info = doctor.doctor_info
    if doctor_info.present?
      doctor_info.feedback_score = Review.joins(:booked_hour).where("booked_hours.doctor_user_id = ?", doctor.id).average(:avg_score)
      doctor_info.feedback_count = Review.joins(:booked_hour).where("booked_hours.doctor_user_id = ?", doctor.id).count
      doctor_info.save!
    end
  end
end
