Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :reports

  namespace :admin do
    root "dashboard#index"
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reports, only: [:index, :show, :destroy]
  end
end