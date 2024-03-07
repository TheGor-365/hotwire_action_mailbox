Rails.application.routes.draw do
  root "contacts#index"
  devise_for :users

  resources :conversations
  resources :contacts
end
