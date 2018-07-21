Rails.application.routes.draw do
  resources :projects, only: [:index, :new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/dashboard" => "dashboard#index"
end
