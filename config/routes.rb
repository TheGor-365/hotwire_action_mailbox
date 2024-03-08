Rails.application.routes.draw do
  root "contacts#index"
  devise_for :users

  resources :conversations do
    resources :posts
  end
  
  resources :contacts
end
