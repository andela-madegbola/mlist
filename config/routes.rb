Rails.application.routes.draw do
  get "/", :to => redirect("/api/docs/index.html")
  resources :users, only: [:create, :destroy]
  post '/auth/login'   => 'auth#login'
  get '/auth/logout'   => 'auth#logout'

  namespace :api do
    namespace :v1 do
      resources :bucketlists do
        resources :items
      end
    end
  end
end