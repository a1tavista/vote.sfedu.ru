require 'sidekiq/web'

Rails.application.routes.draw do
  root "pages#index"

  devise_for :users, path: ""

  get 'login_as', to: 'debug#login_as' if ENV["DEBUG_LOGIN_INTO_ACCOUNT"]

  namespace :student, module: "students" do
    root to: "root#show"
    get "(/*any)" => "root#show"
  end

  namespace :teacher, module: "teachers" do
    root to: "students#index"

    resources :students, only: %i[index]
    resources :surveys
  end

  resources :polls, only: [:show]

  resources :stages do
    get :statistics, on: :member
  end

  resources :surveys do
    get :results, on: :member
    get :respondents, on: :member
  end

  # Admin
  namespace :admin do
    root to: "base#index"

    namespace :support do
      resource :merge_faculties, only: [:show] do
        post :execute
      end
    end

    resources :polls do
      resources :poll_options, module: :polls
    end

    resources :stages
    resources :students do
      resources :raw_teachers, only: [:index], module: :students
    end
    resources :teachers
    resources :questions
    resources :faculties
    resources :users do
      get "admins", action: :index, on: :collection
      get ":kind", action: :index, on: :collection
    end

    namespace :reports do
      resources :teachers, only: [:index] do
        get :lack_of_participations, on: :collection
        get :lack_of_students, on: :collection
      end
      resources :faculties, only: [:index]
    end
  end

  # API
  namespace :api, defaults: {format: :json} do
    namespace :students_api do
      resources :polls, only: [:index, :show] do
        resource :vote, only: [:create], module: 'polls'
      end

      resources :stages do
        resources :teachers, module: 'stages', only: [:index, :show] do
          resource :feedback, module: 'teachers', only: [:show, :create]
          resource :relation, module: 'teachers', only: [:create, :destroy]

          post :refresh, on: :collection
        end

        resource :roster, module: 'stages/teachers', only: [:show]
      end
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
