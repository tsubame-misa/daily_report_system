Rails.application.routes.draw do
  resources :report_calendar, only: %i[index show new day]
  devise_for :users
  root 'home#index'

  resources :users, only: %i[index show edit update destroy]
  resources :reports do
    resources :favorites, only: %i[create destroy]
  end

  namespace :admin do
    root 'dashboard#index'
    get 'calendar', to: 'calendar#index'
    # resources :calendar, only: %i[index]

    resources :users, only: %i[index new create edit update destroy]
    resources :reports, only: %i[index show destroy edit update]
  end

  match '*path', to: 'application#not_found', via: :all
end
