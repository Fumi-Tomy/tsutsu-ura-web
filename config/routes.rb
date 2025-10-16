Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # device
  devise_for :admins, 
              path: '', 
              path_names: {sign_up: 'register', sign_in: 'login', edit: 'profile', sign_out: 'logout'}
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Topページへのルーティング
  root 'static_pages#top'

  # Podcastページへのルーティング
  get 'podcast', to: 'static_pages#podcast'

  resources :posts do
    resources :comments, only: [:create, :destroy] # CommentはPostに紐付いて作成・削除
  end
  resources :tags, only: [:index, :show] # タグの一覧表示や、タグごとの投稿表示
end
