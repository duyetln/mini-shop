# index new create show edit update destroy
Rails.application.routes.draw do
  root 'store#show'

  resource :store, controller: :store, only: [:show]
end
