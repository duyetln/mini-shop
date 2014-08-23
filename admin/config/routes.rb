Rails.application.routes.draw do
  root 'application#index'

  namespace :accounts do
    resources :users, only: [:index, :show]
  end

  namespace :inventory do
    resources :currencies, only: [:index, :create]
    resources :pricepoints, except: [:edit, :new, :destroy]
    resources :discounts, except: [:edit, :new, :destroy]
    resources :prices, except: [:edit, :new, :destroy]

    [:physical_items, :digital_items].each do |items|
      resources items, except: [:show, :new] do
        put :activate, on: :member
      end
    end

    resources :bundles, except: [:new, :edit] do
      put :activate, on: :member
      resources :bundleds, only: :destroy
    end

    resources :store_items, except: [:new, :show]
    resources :promotions, except: [:new, :edit] do
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

  namespace :settings do
    get :clipboard, controller: :clipboard, action: :index
    post :clipboard, controller: :clipboard, action: :create
    delete :clipboard, controller: :clipboard, action: :destroy
  end
end
