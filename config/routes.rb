Refectory::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users" }
  devise_scope :user do
    get 'login', to: "devise/sessions#new", as: "login"
    get 'logout', to: "devise/sessions#destroy", as: "logout"
    get 'signup', to: "users#new", as: "signup"
  end
  root :to => 'high_voltage/pages#show', :id => 'home'
  
  resources :tutorials
  
  if Rails.env == "development"
    match 'errors/404' => 'errors#error_404'
    match 'errors/500' => 'errors#error_500' 
  end
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
