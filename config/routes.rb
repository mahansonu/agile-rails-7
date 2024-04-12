Rails.application.routes.draw do
  
  get 'admin' => 'admin#index'
  controller :sessions do
    get "login" => :new
    post "login" => :create
    delete "logout" => :destroy
  end
  resources :users
  resources :orders
  resources :line_items
  resources :carts
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :support_requests, only: %i[ index update ]

  scope "(:locale)" do
    resources :line_items
    resources :orders
    resources :carts
    root "store#index", as: :store_index, via: :all
  end
end
