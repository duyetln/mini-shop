# index new create show edit update destroy
Rails.application.routes.draw do
  root 'store#show'

  resource :store, controller: :store, only: [:show]
  resource :account, controller: :account, only: [:show, :create, :update] do
    get :sign_in
    get :sign_up
    post :sign_out
    post :verify
    put :password
    post :payment_methods
    post :addresses
  end

  resources :payment_methods, only: [:update]
  resources :purchases, only: [] do
    put :return, on: :member
    resources :orders, only: [] do
      put :return, on: :member
    end
  end
end
