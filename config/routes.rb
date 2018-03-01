Rails.application.routes.draw do
  root 'pages#index'

  devise_for :users, path: ''

  namespace :student do
    root to: 'teachers#index'
    resources :teachers do
      get :refresh, on: :collection
      get :prepare, on: :collection
      post :choose, on: :collection
      post :respond
    end
  end

  namespace :teacher do
    root to: 'students#index'

    resources :students, only: %i(index)
  end

  resources :stages do
    get :statistics, on: :member
  end

  resources :surveys do
    get :results, on: :member
    get :respondents, on: :member
  end

  # Admin

  namespace :admin do
    root to: 'base#index'

    resources :stages
    resources :students
    resources :teachers
    resources :questions
    resources :faculties
    resources :users do
      get 'admins', action: :index, on: :collection
      get ':kind', action: :index, on: :collection
    end

    namespace :reports do
      resources :teachers, only: [] do
        get :lack_of_participations, on: :collection
        get :lack_of_students, on: :collection
      end
    end
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
