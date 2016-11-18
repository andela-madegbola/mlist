Rails.application.routes.draw do
  resources :users, only: :create
  post '/auth/login'   => 'auth#login'
  get '/auth/logout'   => 'auth#logout'
  get 'home' => 'home#index'
end