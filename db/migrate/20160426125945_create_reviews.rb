class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :appointment_id, index: true
      t.text :feedback
      t.float :avg_score
      t.timestamps
    end
  end
end
