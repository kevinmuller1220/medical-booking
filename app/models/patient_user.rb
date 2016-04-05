class PatientUser < User

  has_many :booked_hours, foreign_key: 'patient_user_id', dependent: :delete_all
  has_many :doctor_users, through: :booked_hours

  has_many :reviews, foreign_key: 'doctor_user_id', dependent: :delete_all

  before_create :validate_type
  def validate_type
    if self.type != 'PatientUser'
      self.type = 'PatientUser'
    end
  end

  def pending_appointments
    self.booked_hours.pending.where('booked_hours.from >= ?', Time.now).order('booked_hours.from DESC')
  end

  def upcoming_appointments
    self.booked_hours.approved.where('booked_hours.from >= ?', Time.now).order('booked_hours.from DESC')
  end

  def past_appointments
    self.booked_hours.where('booked_hours.from < ? OR booked_hours.status = ?', Time.now, BookedHour.statuses[:approved]).order('booked_hours.from DESC')
  end
end
