Reijiro::Application.routes.draw do
  resources :clips
  root to: 'clips#index'
end
