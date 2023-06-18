Rails.application.routes.draw do
  resources :articles, only: [:create, :show, :update, :destroy], param: :slug
end
