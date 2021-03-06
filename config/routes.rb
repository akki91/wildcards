Rails.application.routes.draw do
  
  get  'callback'      => 'login#git_callback'
  post 'webhooks'       => 'webhooks#create'

  # PR APIs
  get 'prs'                     => 'prs#index'
  post 'prs/:id'                => 'prs#update'
  post 'update_pr_status'       => 'prs#update_pr_status'

  # Team APIs
  get 'teams/suggest'  => 'teams#autocomplete'
  get 'teams'          => 'teams#index'
  post 'teams'         => 'teams#create'  
  post '/update/teams/'   => 'teams#update' # Add or remove team members
  

  # User APIs
  get 'users/suggest'  => 'users#autocomplete'
  get 'users/:id'      => 'users#show'
  get 'users'          =>  'users#index'  
  

  # Features
  get 'features'                => 'features#index'
  get 'features/suggest'        => 'features#autocomplete'

  get 'stats'            => 'users#stats'

  get 'suggest-pr-reviewer' => 'teams#auto_suggest_reviewer' 
  post 'delete-team'    => 'teams#delete_team'
  post 'update-team'    => 'teams#update_team'

  ##repo 

  get 'repo'              => 'repo#index'
end
