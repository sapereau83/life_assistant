Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :tasks, only: %i[create update destroy] do
    member do
      patch :complete
      patch :reopen
      patch :move_to_today
    end
  end
  get "today" => "tasks#index", as: :today
  get "dashboard" => "dashboard#index", as: :dashboard

  resources :weight_entries, only: %i[index create update destroy]
  resources :meals, only: %i[index create update destroy]
  resources :workouts, only: %i[index create update destroy]

  # Defines the root path route ("/")
  root "dashboard#index"
end
