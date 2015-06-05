Myflix::Application.routes.draw do
  root to: 'static_pages#landing'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: "videos#index"

  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/sign_out', to: "sessions#destroy"
  get '/register', to: "users#new"

  resources :videos do
    collection do
      get '/search', action: :search
    end

    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
  resources :users, only: [:create, :new, :show]
end
