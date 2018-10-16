Rails.application.routes.draw do
  resources :expenses, only: [:create, :index, :destroy]
  resources :invoices, only: [:create, :index]
  resource :pay_rate, only: [:show, :new, :create]
  resources :exports, only: [:create]
  resources :logs, only: [:index, :create, :edit, :update, :destroy]
  resources :projects, only: [:index, :new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/dashboard" => "dashboard#index"

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  root "home#index"
end
