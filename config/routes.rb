Rails.application.routes.draw do
  root 'pages#index'

  devise_for :users, path: ''

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

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
