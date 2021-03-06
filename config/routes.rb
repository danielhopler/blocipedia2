Rails.application.routes.draw do

  devise_for :users
  resources :wikis

  resources :wikis do
    resources :collaborators, only: [:index, :create, :destroy]
  end

  resources :charges, only: [:new, :create]

  delete 'charges/downgrade'

  get 'welcome/about'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
