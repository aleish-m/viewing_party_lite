Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get '/login', to: 'session#new'
  resource :login, only: [:create, :destroy], controller: :session

  resource :register, only: [:create, :new], controller: :users
  resource :dashboard, only: [:show], controller: :users

  get '/discover', to: 'discover#index'
  resources :movies, only: [:show, :index] do
    resource :viewing_party, only: [:new, :create]
  end

  
  resources :movies, only: [:show]
end
