Rails.application.routes.draw do

  root :to => 'users#index'
  resources :sessions
  resources :users

  get 'login' => 'sessions#new', :as => :login
  delete 'logout' => 'sessions#destroy', :as => :logout

end
