Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Solid Queue monitoring dashboard. Dev-only (gem is in the :development
  # group) and ships without auth — if you ever mount it in production, wrap
  # it in an authenticated constraint. The `defined?` guard keeps route
  # reloading safe in processes that don't load the gem (e.g. bin/jobs).
  mount SolidQueueDashboard::Engine, at: "/solid-queue" if defined?(SolidQueueDashboard::Engine)

  resources :tasks, only: %i[create update destroy] do
    member do
      patch :complete
      patch :reopen
      patch :move_to_today
      patch :toggle_recurring
    end
  end
  resources :recurring_tasks, only: %i[create destroy]
  get "today" => "tasks#index", as: :today
  get "todos" => "tasks#list", as: :todos
  get "dashboard" => "dashboard#index", as: :dashboard

  resources :weight_entries, only: %i[index create update destroy]
  resources :meals, only: %i[index create update destroy]
  resources :workouts, only: %i[index create update destroy]

  # Defines the root path route ("/")
  root "dashboard#index"
end
