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

  scope :corp do
    devise_for :corporate_users
  end

  root "users#show"

  get    "/users/sign_in",  to: "users/sessions#new"
  post   "/users/sign_in",  to: "users/sessions#create"
  delete "/users/sign_out", to: "users/sessions#destroy"

  resources :users, only: [:show]

  get    "/items",          to: "items#index"

  resources :lendings, only: [:new, :create, :edit, :update]

end
