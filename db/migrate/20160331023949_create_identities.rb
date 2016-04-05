class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :token
      t.datetime :expires_at
      t.references :user
      t.timestamps null: false
    end
    add_index :identities, :user_id
    add_index :identities, [:provider, :uid], unique: true
  end
end
