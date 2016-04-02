class CreateSpecialities < ActiveRecord::Migration
  def up
    create_table :specialities do |t|
      t.string :name,              null: false, default: ""
      t.string :slug,              null: false, default: ""
      t.timestamps                 null: false
    end

    add_attachment :specialities, :image
    add_index :specialities, :slug, unique: true
  end

  def down
    drop_table(:specialities)
  end
end
