class Appointment < ActiveRecord::Base
  belongs_to :doctor, class_name: 'DoctorUser', foreign_key: 'doctor_user_id'
  belongs_to :patient, class_name: 'PatientUser', foreign_key: 'patient_user_id'

  # scope :upcoming_appointments, -> {where('appointment_date BETWEEN ? AND ?', Time.now, Time.now + 6.hours).order('appointment_date ASC')}
  scope :upcoming_appointments, -> {where('appointment_date > ?', Time.now).order('appointment_date ASC')}
  scope :starting_next_hour, -> {where('appointment_date BETWEEN ? AND ?', Time.now, Time.now + 1.hours).order('appointment_date ASC')}
  scope :past_appointments, -> { where('appointment_date < ?', Time.now).order('appointment_date ASC') }

  def starting_in_3_hours?
    self.appointment_date <= Time.now + 3.hours
  end
end
