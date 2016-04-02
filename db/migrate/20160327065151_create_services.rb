class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name,             null: false
      t.string :slug,             null: false, default: ""
      t.integer  :speciality_id,  null: false
      t.timestamps                null: false
    end
    add_foreign_key :services, :specialities
  end
end
