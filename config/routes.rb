Rails.application.routes.draw do
  devise_for :users, path: ''
  root 'pages#index'

  resources :teachers do
    post :respond
  end

  resources :stages do
    # get :results, on: :member
  end
end
