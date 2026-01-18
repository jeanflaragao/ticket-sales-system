# Edit routes file
Rails.application.routes.draw do
  # Health check
  get "/health", to: "health#show"
  root "health#show"
  
  # Shows API
  resources :shows, only: [:index, :show, :create, :update] do
    member do
      get :availability
    end
  end
  
  # Orders API
  resources :orders, only: [:index, :show, :create] do
    member do
      post :cancel
    end
  end
end