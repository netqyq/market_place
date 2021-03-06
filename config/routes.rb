require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

# Api definition
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/'  do
    # We are going to list our resources here
    scope module: :v1 do
      # We are going to list our resources here
      constraints ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
        resources :users, :only => [:show, :create, :update, :destroy] do 
          resources :products, :only => [:create, :update, :destroy]
          resources :orders, :only => [:index, :show, :create]
        end
        resources :sessions, :only => [:create, :destroy]
        resources :products, :only => [:show, :index]
      end
    end
  end
end
