Newtone::Application.routes.draw do
  root :to => "home#index"
  match 'api/query' => 'api#query'
  match 'recognize' => 'recognition#recognize'
  match 'record' => 'recognition#record'
  match 'test' => 'home#test'
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
end
