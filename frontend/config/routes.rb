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
end
