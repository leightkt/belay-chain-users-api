Rails.application.routes.draw do
  resources :administrators
  resources :members
  resources :gyms
  post "/gymlogin", to: "gyms#login"
  post "/memberlogin", to: "members#login"
  post "/adminlogin", to: "administrators#login"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
