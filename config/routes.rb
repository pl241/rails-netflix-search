Rails.application.routes.draw do
  get "about", to: 'pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :videos, only: [:index, :show]

  # root 'videos#index'
  root to: 'videos#index'
end
