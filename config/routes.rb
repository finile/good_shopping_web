Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "products#index"

  resources :products, only: [:index, :show] do
    member do 
      post :add_to_cart
      post :remove_from_cart
      post :adjust_item
    end
  end


  namespace :admin do
    resources :products
    root "products#index"
  end

  resource :cart 
  resources :orders

end
