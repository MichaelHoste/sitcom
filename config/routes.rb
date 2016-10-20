require 'sidekiq/web'

Rails.application.routes.draw do

  # Devise

  devise_for :users

  # Sidekiq

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Admin

  namespace :admin do
    resources :users do
      resources :lab_user_links do
        collection do
          put :update_many
        end
      end

      resource :api_key do
        member do
          put :reset
        end
      end
    end

    resources :labs do
      resources :custom_fields
    end

    resources :fields do
      resources :children, controller: 'fields'
    end

    root to: 'users#index', as: :root
  end

  # API

  namespace :api do
    resources :users, only: [:index, :show, :create, :update, :destroy] do
      resources :permissions, :controller => :lab_user_links,
                              :only       => [:index, :show, :update, :destroy]
    end

    resources :labs, only: [:index, :show] do
      resources :contacts, only: [:index, :show, :create, :update, :destroy] do
        resources :organizations, only: [:index, :show]
        resources :projects,      only: [:index, :show]
        resources :events,        only: [:index, :show]
        resources :tags,          only: [:index, :create]

        delete '/tags' => 'tags#destroy'
      end

      resources :organizations, only: [:index, :show]
      resources :projects,      only: [:index, :show]
      resources :events,        only: [:index, :show]

      resources :tags, only: [:index]
    end
  end

  # App

  resource :profile do
    resource :password
    resource :current_lab
  end

  resources :labs, :path => ''
  resources :labs, :path => '', :only => [] do
    resources :contacts do
      resources :notes
      resources :custom_fields

      collection do
        get :options
        get :export

        resources :saved_searches, :item_type => 'contact'
      end
    end

    resources :organizations do
      resources :notes

      collection do
        get :options
        get :status_options
        get :export

        resources :saved_searches, :item_type => 'organization'
      end
    end

    resources :projects do
      resources :notes

      collection do
        get :options

        resources :saved_searches, :item_type => 'project'
      end
    end

    resources :events do
      resources :notes

      collection do
        get :options

        resources :saved_searches, :item_type => 'event'
      end
    end

    resources :fields do
      collection do
        get :options
      end
    end

    resources :tags do
      collection do
        get :options
      end
    end
  end

  root to: 'labs#index'
end
