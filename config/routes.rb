Rails.application.routes.draw do
  devise_for :authors
  root "articles#index"
  resources :authors

  resources :articles do
    resources :comments
  end


end
