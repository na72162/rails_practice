class ChangeDeleteFlgInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :delete_flg, :boolean, default: true
  end
end

