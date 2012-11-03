Crisco::Application.routes.draw do
  devise_for :users

  resources :links

  root to: 'links#index'

  match '/:id' => 'links#show', as: :short_link
end
