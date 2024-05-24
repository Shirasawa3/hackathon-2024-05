Rails.application.routes.draw do
  devise_for :corporate_users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :corp do
    resources :items, only: [:index, :show, :new, :create, :edit, :update]
  end
end
