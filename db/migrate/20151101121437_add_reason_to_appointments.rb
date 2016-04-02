class AddReasonToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :reason, :text
  end
end
