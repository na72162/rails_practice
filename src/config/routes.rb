Rails.application.routes.draw do
root "static_pages#home"

# new（新規作成フォーム）

get '/users/new', to: 'users#new', as: 'users_new'

# create（新規作成）
# 基本的にはデータの経由の役割なので専用画面はいらない
post '/users', to: 'users#create'

# show（詳細表示）
get '/users/:id', to: 'users#show'

# edit（編集フォーム）
get '/users/:id/edit', to: 'users#edit'

# update（更新）
patch '/users/:id', to: 'users#update'
put '/users/:id', to: 'users#update'

# destroy（削除）
delete '/users/:id', to: 'users#destroy'

# asは_を使う際は複数のファイルを跨ぐ際などに使う：例get '/users/new',
# to: 'users#new', as: 'users_new'
get '/mypage', to: 'mypage#index', as: 'mypage'

end
