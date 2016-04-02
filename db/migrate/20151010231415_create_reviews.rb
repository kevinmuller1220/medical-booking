class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body
      t.integer :doctor_user_id, index: true
      t.integer :patient_user_id, index: true

      t.timestamps
    end
  end
end
