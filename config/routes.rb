Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users, only: %i[index show edit update destroy]
  resources :reports do
    resources :favorites, only: %i[create destroy]
  end

  namespace :admin do
    root 'dashboard#index'
    resources :users, only: %i[index new create edit update destroy]
    resources :reports, only: %i[index show destroy]
  end

  match '*path', to: 'application#not_found', via: :all
end
