Rails.application.routes.draw do
  
  get  'callback'      => 'login#git_callback'
  post 'webhooks'       => 'webhooks#create'

  # PR APIs
  get 'prs'                     => 'prs#index'
  post 'prs/:id'                => 'prs#update'
  post 'update_pr_status'                => 'prs#update_pr_status'

  # Team APIs
  get 'teams/suggest'  => 'teams#autocomplete'
  get 'teams'          => 'teams#index'
  post 'teams'         => 'teams#create'  
  put 'teams/:id'   => 'teams#update' # Add or remove team members
  

  # User APIs
  get 'users/suggest'  => 'users#autocomplete'
  get 'users/:id'      => 'users#show'
  

  # Features
  get 'features'                => 'features#index'
  get 'features/suggest'        => 'features#autocomplete'

  get 'stats'            => 'users#stats'
end
