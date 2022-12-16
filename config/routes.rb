Rails.application.routes.draw do
  resource :auth, only: [:new]
  get '/auth', to: redirect('auth/new')

  resource :login, only: [:show, :destroy], controller: 'login'

  resource :dashboard, only: [:show]

  root to: 'dashboards#show'
end
