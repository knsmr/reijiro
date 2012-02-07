Reijiro::Application.routes.draw do
  resources :words, only: [:index, :show]
  resources :clips
  match '/nextup' => 'clips#nextup', as: 'nextup'
  root to: 'clips#index'
end
