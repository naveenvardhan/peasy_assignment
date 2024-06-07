Rails.application.routes.draw do

  resources :users, only: [:index, :destroy]
  get 'daily_records', to: 'daily_records#index'
  
  root "users#index"
end
