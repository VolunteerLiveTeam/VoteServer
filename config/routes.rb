Rails.application.routes.draw do
  root 'index#index'

  get 'vote/', to: 'vote#index', as: :vote_noslug
  get 'vote/begin/:slug', to: 'vote#index', as: :vote

  post 'vote/confirm', to: 'vote#confirm'

  post 'vote/create', to: 'vote#create'

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
