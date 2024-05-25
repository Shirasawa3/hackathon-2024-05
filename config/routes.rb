Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope :corp do
    devise_for :corporate_users
  end

  namespace :corp do
    resources :items, only: [:index, :show, :new, :create, :edit, :update]
    resources :users, only: [:index, :show]
    resources :corporate_users, only: [:index]
  end
end
