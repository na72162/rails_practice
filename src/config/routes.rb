Rails.application.routes.draw do
root "static_pages#home"

# new（新規作成フォーム）

get '/signup/new', to: 'users#new', as: 'signup_new'

# create（新規作成）
# 基本的にはデータの経由の役割なので専用画面はいらない
resources :users, only: [:create]

get  "/login/new",  to: "sessions#new", as: 'login_new'
post "/login/create",  to: "sessions#create"
delete '/logout', to: 'sessions#destroy', as: 'logout_destroy'

# edit（編集フォーム）
get '/signup/:id/edit', to: 'users#edit'

# update（更新）
patch '/signup/:id', to: 'users#update'
put '/signup/:id', to: 'users#update'

# destroy（削除）
delete '/signup/:id', to: 'users#destroy'

# show（詳細表示）
get '/mypage/:id', to: 'mypage#show'

# resources :password_resets,     only: [:new, :create, :edit, :update]
# asは_を使う際は複数のファイルを跨ぐ際などに使う：例get '/users/new',
# to: 'users#new', as: 'users_new'
get '/mypage', to: 'mypage#index', as: 'mypage'

end
