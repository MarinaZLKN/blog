Rails.application.routes.draw do
  root "articles#index"
  resources :authors


  resources :articles do
    resources :comments
  end


end
