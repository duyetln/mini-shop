Rails.application.routes.draw do
  root 'application#index'

  namespace :accounts do
    resources :users, only: [:index, :show]
  end

  namespace :inventory do
    resources :currencies, only: [:create]
    resources :pricepoints, except: [:show]
    resources :discounts, only: [:index, :create, :update]
    resources :prices, only: [:index, :create, :update]

    [:physical_items, :digital_items].each do |items|
      resources items, only: [:index, :create, :update, :destroy] do
        put :activate, on: :member
      end
    end

    resources :bundles, only: [:index, :show, :create, :update, :destroy] do
      put :activate, on: :member
      resources :bundleds, only: :destroy
    end

    resources :store_items, only: [:index, :show, :create, :update, :destroy]
    resources :promotions, only: [:index, :show, :create, :update, :destroy] do
      put :activate, on: :member
      post :batches, on: :member
    end

    resources :batches, only: [:show, :update, :destroy] do
      put :activate, on: :member
      post :coupons, on: :member
    end
  end

  namespace :shopping do
    resources :purchases, only: :show do
      put :return, on: :member
      resources :orders, only: [] do
        put :return, on: :member
      end
    end
  end
end
