class BookedHour < ActiveRecord::Base
  belongs_to :doctor_user, class_name: 'DoctorUser', foreign_key: 'doctor_user_id'
end
