# Edit routes file
Rails.application.routes.draw do
  # Health check
  get "/health", to: "health#show"
  root "health#show"
  
  resources :shows do
    get :availability, on: :member
  end
  
  # Orders API
  resources :orders, only: [:index, :show, :create] do
    member do
      post :cancel
    end
  end
end