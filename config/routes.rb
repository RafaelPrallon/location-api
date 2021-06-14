Rails.application.routes.draw do
  resources :locations, only: %i[index create] do
    resources :ratings
  end

  post 'locations/list'
  post 'locations/map'

  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }
end
