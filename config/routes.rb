Reijiro::Application.routes.draw do
  resources :words, except: [:new]
  resources :clips, only: [:index, :update, :destroy]

  match '/search' => 'words#search', as: 'search'
  match '/alc(/:level)' => 'words#import_from_alc12000', as: 'alc', via: :post
  match '/import/' => 'words#import', as: 'import'
  match '/stats' => 'clips#stats', as: 'stats'
  match '/next' => 'clips#nextup', as: 'next'
  root to: 'clips#next'
end
