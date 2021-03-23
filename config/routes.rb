Rails.application.routes.draw do
  resources :administrators
  resources :members
  resources :gyms
  post "/gymlogin", to: "gyms#login"
  post "/memberlogin", to: "members#login"
  post "/adminlogin", to: "administrators#login"
  get "/profile", to: "application#profile"
  post "/findMember", to: "members#find_member_by"
  post "/addCertification", to: "gyms#add_certification"
end
