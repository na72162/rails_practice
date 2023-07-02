class AddSessionTokenColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :session_token,:integer
  end
end
