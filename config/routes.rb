Rails.application.routes.draw do
  devise_scope :user do
    root to: 'users/sessions#new'
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  devise_for :users
  resources :users, only: [:index, :show]
  resources :books

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
