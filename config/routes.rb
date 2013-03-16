Newtone::Application.routes.draw do
  root :to => "home#index"
  match 'api/query' => 'api#query'
  match 'recognize' => 'recognition#recognize'
end
