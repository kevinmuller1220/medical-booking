class PatientUser < User

  has_many :appointments, foreign_key: 'patient_user_id'
  has_many :doctor_users, through: :appointments, class_name: "DoctorUser"

  has_many :reviews, foreign_key: 'doctor_user_id'

  before_create :validate_type
  def validate_type
    if self.type != 'PatientUser'
      self.type = 'PatientUser'
    end
  end

end
