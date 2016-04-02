class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :doctor_user_id, index: true
      t.integer :patient_user_id, index: true
      t.datetime :appointment_date

      t.timestamps
    end
  end
end
