Crisco::Application.routes.draw do
  devise_for :users

  resources :links

  match '/:id' => 'links#show', as: :short_link
end
