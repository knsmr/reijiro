Reijiro::Application.routes.draw do
  resources :words, except: [:new]
  resources :clips, only: [:index, :update, :destroy]
  resources :levels, only: [:index, :show]

  match '/search' => 'words#search', as: 'search'
  match '/alc(/:level)' => 'words#import_from_alc12000', as: 'alc', via: :post
  match '/stats' => 'clips#stats', as: 'stats'
  match '/next' => 'clips#nextup', as: 'next'
  match '/import' => 'words#import', as: 'import', via: :post

  root to: 'clips#next'
end
