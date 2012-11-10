Crisco::Application.routes.draw do
  devise_for :users

  root to: 'links#index'

  resources :links, only: [:show, :create, :destroy, :index]

  get '/l' => 'links#create', as: :get_create_link

  match '/:id' => 'links#show', as: :short_link
end
