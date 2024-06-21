Rails.application.routes.draw do
  get 'members/index'
  get 'groups/index'
  root "groups#index"

  get "/members", to:"members#index"
end
