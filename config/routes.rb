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


  class ErrorAvoid
    def initialize
      @url = "active_storage/"
    end

    def matches?(request)
      @url.include?(request.url)
    end
  end

  #Rails.application.routes.draw do
    get '*not_found', to: 'application#routing_error', constraints: ErrorAvoid.new
  #end
  post '*not_found', to: 'application#routing_error'

  mount Sidekiq::Web, at: '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
