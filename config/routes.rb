Rails.application.routes.draw do
  resources :administrators
  resources :members
  resources :gyms
  post "/login", to: "application#login"
  get "/profile", to: "application#profile"
  post "/findMember", to: "members#find_member_by"
  post "/addCertification", to: "gyms#add_certification"
  post "/verify", to: "application#verify"
end
