class ChangeDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :name
    change_column :users, :email, :string, unique: true
  end
end
