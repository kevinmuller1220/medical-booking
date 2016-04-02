class CreateOpenHours < ActiveRecord::Migration
  def change
    create_table :open_hours do |t|
      t.integer :doctor_user_id
      t.string :title
      t.time :to
      t.time :from
      t.timestamps
    end
    add_foreign_key :open_hours, :users, column: :doctor_user_id
  end
end
