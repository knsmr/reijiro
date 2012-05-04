Reijiro::Application.routes.draw do
  resources :words, except: [:new]
  resources :clips, only: [:index, :update, :destroy]

  match '/search' => 'words#search', as: 'search'
  match '/import(/:level)' => 'words#import_from_alc12000', as: 'importalc'
  match '/stats' => 'clips#stats', as: 'stats'
  match '/next' => 'clips#nextup', as: 'next'
  root to: 'clips#next'
end
