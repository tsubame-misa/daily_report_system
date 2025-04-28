Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users, only: %i[index show edit update destroy]
  resources :reports

  namespace :admin do
    get 'reports/index'
    get 'reports/show'
    get 'reports/destroy'
    get 'users/index'
    get 'users/new'
    get 'users/create'
    get 'users/edit'
    get 'users/update'
    get 'users/destroy'
    root 'dashboard#index'
    resources :users, only: %i[index new create edit update destroy]
    resources :reports, only: %i[index show destroy]
  end

  match '*path', to: 'application#not_found', via: :all
end
