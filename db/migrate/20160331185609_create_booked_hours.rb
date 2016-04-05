class CreateBookedHours < ActiveRecord::Migration
  def change
    create_table :booked_hours do |t|
      t.integer :doctor_user_id
      t.integer :patient_user_id
      t.string :title
      t.datetime :from
      t.datetime :to
      t.column :status, :integer, default: 0
      t.timestamps
    end
    add_foreign_key :booked_hours, :users, column: :doctor_user_id
    add_foreign_key :booked_hours, :users, column: :patient_user_id
  end
end
