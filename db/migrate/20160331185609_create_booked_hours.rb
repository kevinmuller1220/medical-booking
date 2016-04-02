class CreateBookedHours < ActiveRecord::Migration
  def change
    create_table :booked_hours do |t|
      t.integer :doctor_user_id
      t.string :title
      t.datetime :from
      t.datetime :to
      t.timestamps
    end
    add_foreign_key :booked_hours, :users, column: :doctor_user_id
  end
end
