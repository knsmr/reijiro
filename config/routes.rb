Reijiro::Application.routes.draw do
  resources :words, only: [:index, :show]
  resources :clips
  root to: 'clips#index'
end
