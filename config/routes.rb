require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  devise_scope :user do
    root "users/sessions#new"
  end

  devise_for :users,  controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, only: [:show]

  namespace :admin do
    resources :users, only: [:index, :destroy]
  end
  resources :expendable_items

  resources :about_app, only: [:index]

  authenticate :user do #authenticate
    mount Sidekiq::Web => '/sidekiq'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
