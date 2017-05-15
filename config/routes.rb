Rails.application.routes.draw do
  resources :crashes,   only: [:create]
  resources :dashboard, only: [:index]
  resources :order,     only: [:index, :new, :create]
  resources :releases,  only: [:index, :show]
  resources :session,   only: [:new] do
    collection do
      delete :destroy
    end
  end
  resources :tokens,    only: [:create]
  resources :update,    only: [:show], constraints: { id: /\d+\.\d+\.\d+/ }
  resources :webhooks,  only: [:create]

  namespace :administration do
    resources :crashes
    resources :discounts
    resources :orders
    resources :refunds
    resources :releases
    resources :users

    root to: "orders#index"
  end

  get "privacy" => "pages#privacy"
  get "refunds" => "pages#refunds"
  get "sketch"  => "pages#sketch"
  get "terms"   => "pages#terms"

  root to: "pages#index"
end
