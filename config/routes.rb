Reijiro::Application.routes.draw do
  resources :words, only: [:index, :show]
  resources :clips, only: [:index, :update, :detroy]

  match '/search' => 'words#search', as: 'search'
  match '/import(/:level)' => 'words#import_from_alc12000', as: 'importalc'
  match '/nextup' => 'clips#nextup', as: 'nextup'
  match '/next' => 'clips#next', as: 'next'
  root to: 'clips#index'
end
