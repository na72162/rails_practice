class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_column :users, :age, :integer
    add_column :users, :tel, :string
    add_column :users, :zip, :integer
    add_column :users, :pic, :string
    add_column :users, :addr, :string
    add_column :users, :password, :string
    add_column :users, :delete_flg, :boolean
    add_column :users, :login_time, :timestamp
  end
end

# 生成コマンドは
# rails generate migration AddDetailsToUsers
# その後rails db:migrate
# add_column: 新たにカラムを追加します。
# remove_column: 既存のカラムを削除します。
# change_column: 既存のカラムの型を変更します。
# rename_column: 既存のカラムの名前を変更します

# 例
# class ModifyUsers < ActiveRecord::Migration[6.1]
#   def change
#     # カラムに属性を追加する
#     add_index :users, :email, unique: true

#     # カラムを削除する
#     remove_column :users, :age

#     # カラムの型を変更する
#     change_column :users, :tel, :integer

#     # カラムの名前を変更する
#     rename_column :users, :pic, :picture
#   end
# end

# upとdownメソッドというchangeメソッドの箇所に入るけど最近はchangeメソッドが基本勝手に切り替えてくれる。
#複雑な変更の場合は指定する必要がある。

