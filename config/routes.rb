Rails.application.routes.draw do
  devise_for :users, path: ''
  root 'pages#index'

  resources :teachers do
    get :prepare, on: :collection
    post :choose, on: :collection
    post :respond
  end

  resources :stages

  resources :surveys do
    get :results, on: :member
    get :respondents, on: :member
  end

  # API
  namespace :api, defaults: { format: :json } do
    resources :surveys, only: [] do
      get :questions, on: :member
      post :answers, on: :member
    end
  end
end
