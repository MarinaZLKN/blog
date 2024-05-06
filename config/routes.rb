Rails.application.routes.draw do
  devise_for :authors, controllers: { registrations: 'registrations' }
  root "articles#index"
  resources :authors

  resources :articles do
    resources :comments
  end


end
