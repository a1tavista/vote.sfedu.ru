Rails.application.routes.draw do
  devise_for :users, path: ''
  root 'pages#index'

  resources :teachers do
    post :respond
  end

  resources :stages do
    # get :results, on: :member
  end

  resources :surveys

  # API
  namespace :api, defaults: { format: :json } do
    resources :surveys, only: [] do
      get :questions, on: :member
      post :answers, on: :member
    end
  end
end
