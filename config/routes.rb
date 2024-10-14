Rails.application.routes.draw do
  devise_scope :user do
    root to: 'users/sessions#new'
  end
  devise_for :users
  resources :users, only: [:index, :show, :destroy]
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
