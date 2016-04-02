class CreateDoctorInfos < ActiveRecord::Migration
  def change
    create_table :doctor_infos do |t|
      t.integer :doctor_user_id
      t.string :website
      t.integer :speciality_id
      t.boolean :house_calls, default: false
      t.text :days, array: true, default: []
      t.time :hours_from
      t.time :hours_to
      t.text :bio
      t.timestamps null: false
    end
    add_foreign_key :doctor_infos, :users, column: :doctor_user_id
  end
end
