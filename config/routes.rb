Rails.application.routes.draw do
  devise_for :users, path: ''
  root 'high_voltage/pages#show', id: 'index'
end
