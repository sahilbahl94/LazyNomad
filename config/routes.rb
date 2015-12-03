Rails.application.routes.draw do
    root to: "queries#index"
  devise_for :users
  resources :queries, only: [:index]

  get "/home" => "queries#home"
  post "/saved" => "queries#saved"
  get "/near_me" => "queries#near_me"
  get "/show" => "queries#show"
  get "/saved_places" => "queries#saved_places"

 end
