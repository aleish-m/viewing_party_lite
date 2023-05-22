Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get '/discover', to: 'discover#index'
  
  get '/login', to: 'session#new'
  resource :login, only: [:create, :destroy], controller: :session
  
  get '/register', to: 'users#new'
  resource :register, only: [:create], controller: :users
  
  resource :dashboard, only: [:show], controller: :users

  resources :movies, only: [:show, :index] do
    resource :viewing_party, only: [:new, :create]
  end

end
