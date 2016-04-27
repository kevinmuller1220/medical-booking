class AddReviewsFieldsToDoctorsInfos < ActiveRecord::Migration
  def change
    add_column :doctor_infos, :feedback_count, :integer, default: 0
    add_column :doctor_infos, :feedback_score, :float, default: 0
  end
end
