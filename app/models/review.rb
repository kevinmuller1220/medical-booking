class Review < ActiveRecord::Base
  belongs_to :booked_hour, class_name: 'BookedHour', foreign_key: "appointment_id"

  after_create :update_doctor_reviews

  def update_doctor_reviews
    doctor = self.booked_hour.doctor_user
    doctor.update_reviews!
  end
end
