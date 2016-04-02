class AddAdditionalFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :phone, :string
    add_column :users, :bizname, :string
  end
end
