Rails.application.routes.draw do

  get 'oauths/oauth'

  get 'oauths/callback'

  root :to => 'users#index'
  resources :sessions
  resources :users

  get 'login' => 'sessions#new', :as => :login
  delete 'logout' => 'sessions#destroy', :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider  

end
