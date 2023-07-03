Rails.application.routes.draw do
root "static_pages#home"

# new（新規作成フォーム）

get '/signup/new', to: 'users#new', as: 'signup_new'

# create（新規作成）
# 基本的にはデータの経由の役割なので専用画面はいらない
resources :users, only: [:create]

get  "/login/new",  to: "sessions#new", as: 'login_mew'
post "/login/create",  to: "sessions#create",as: 'login_create'
delete '/logout', to: 'sessions#destroy'

# show（詳細表示）
get '/mypage/:id', to: 'mypage#show'

# resources :password_resets,     only: [:new, :create, :edit, :update]
# asは_を使う際は複数のファイルを跨ぐ際などに使う：例get '/users/new',
# to: 'users#new', as: 'users_new'
get '/mypage', to: 'mypage#index', as: 'mypage'

end
