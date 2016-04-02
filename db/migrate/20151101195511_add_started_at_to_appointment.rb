class AddStartedAtToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :started_at, :time
    add_column :appointments, :ended_at, :time
  end
end
