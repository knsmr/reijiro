Reijiro::Application.routes.draw do
  resources :words, except: [:new]
  resources :clips, only: [:index, :update, :destroy]

  match '/clips/all' => 'clips#all', as: 'all_clips'

  match '/levels/' => 'levels#index', as: 'levels'
  match '/levels/:level' => 'levels#show', as: 'level'
  match '/levels/known/:id' => 'levels#known', as: 'known', via: :post

  match '/search' => 'words#search', as: 'search'
  match '/alc(/:level)' => 'words#import_from_alc12000', as: 'alc', via: :post
  match '/stats' => 'clips#stats', as: 'stats'
  match '/next' => 'clips#nextup', as: 'next'
  match '/import' => 'words#import', as: 'import', via: :post
  match '/async_import/:word' => 'words#async_import', via: :post

  root to: 'clips#next'
end
