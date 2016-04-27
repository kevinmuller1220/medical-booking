class BookedHour < ActiveRecord::Base
  belongs_to :doctor_user, class_name: 'DoctorUser', foreign_key: 'doctor_user_id'
  belongs_to :patient_user, class_name: 'PatientUser', foreign_key: 'patient_user_id'

  has_one :review, dependent: :delete, foreign_key: "appointment_id"

  enum status: [ :pending, :imported, :approved, :canceled ]

  def has_feedback?
    self.review.present?
  end
end
