Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  
  resources :users, only: [:index, :show, :edit, :update, :destroy]
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
    root "dashboard#index"
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reports, only: [:index, :show, :destroy]
  end
end