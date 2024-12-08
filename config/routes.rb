require 'sidekiq/web'
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :inventories, only: [:index, :show] do
        collection do
          post :import_csv
        end
      end

      resources :orders, only: [:create]
    end
  end
  mount Sidekiq::Web => '/sidekiq'
end
