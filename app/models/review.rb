class Review < ActiveRecord::Base
  belongs_to :patient, foreign_key: "patient_user_id"
  belongs_to :doctor, foreign_key: "doctor_user_id"
end
