Rails.application.routes.draw do
  
  get  'callback'      => 'login#git_callback'
  post 'webhooks'       => 'webhooks#create'

  # PR APIs
  get 'prs'                     => 'prs#index'
  post 'prs/:id'                => 'prs#update'

  # Team APIs
  get 'teams'          => 'teams#index'
  post 'teams'         => 'teams#create'
  put 'teams/:id'   => 'teams#update' # Add or remove team members
  get 'teams/suggest'  => 'teams#autocomplete'

  # User APIs
  get 'users/:id'      => 'users#show'
  get 'users/suggest'  => 'users#autocomplete'

  # Features
  get 'features'                => 'features#index'
  get 'features/suggest'        => 'features#autocomplete'


end
