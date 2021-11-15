Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :accounts, controllers: { omniauth_callbacks: 'accounts/omniauth_callbacks' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # dashboard
  get "/dashboard" => "accounts#index"
  get "profile/:username" => "accounts#profile", as: :profile
  get "post/like/:post_id" => "likes#save_like", as: :like_post
  post "follow/account" => "accounts#follow_account", as: :follow_account
  post "unfollow/account" => "accounts#unfollow_account", as: :unfollow_account

  get "following/:username" => "accounts#following", as: :all_following
  get "followers/:username" => "accounts#followers", as: :all_followers

  get "search" => "accounts#search", as: :search

  resources :posts, only: [:new, :create, :show]
  resources :comments, only: [:create]
  resources :banners

  get "advertise" => "public#advertise", as: :advertise

  root to: "public#homepage"

end
