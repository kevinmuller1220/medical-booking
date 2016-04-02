class DoctorInfo < ActiveRecord::Base
  belongs_to :doctor_user, class_name: 'DoctorUser', foreign_key: 'doctor_user_id'
  belongs_to :speciality
end
