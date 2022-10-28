Rails.application.routes.draw do
  get 'channels/open'
  get 'home', to: "static#home", as: "home"
  get 'features', to: "static#features", as: "features"
  get 'legal', to: "static#legal", as: "legal"
  get 'about', to: "static#about", as: "about"
  get 'error', to: "static#error", as: "error"
  
  get "swaps", to: "swaps#index", as: "swaps"
  get "swaps/new", to: "swaps#new", as: "new_swap"
  get "swaps/:id", to: "swaps#show", as: "swap"
  match "swaps", to: "swaps#create", via: :post
  
  match "subscriptions", to: "subscriptions#create", via: :post
  match "subscription_completed", to: "subscriptions#completed", via: :post

  get "verify_signature", to: "swaps#verify_signature", as: "verify_signature"
  get "auto_verify_signature", to: "swaps#auto_verify_signature", as: "auto_verify_signature"
  
  get "for_me", to: "swaps#for_me", as: "for_me"
  get "to_dos", to: "swaps#to_dos", as: "to_dos"
  get "my_swaps", to: "swaps#my_swaps", as: "my_swaps"
  
  get "comments/new/:id", to: "comments#new", as: "new_comment"
  get "comments/:id", to: "comments#show", as: "comment"
  match "comments/:id", to: "comments#create", via: :post

  match "channel_open", to: "channels#open", via: :post

  match "ratings", to: "ratings#create", via: :post

  get "account", to: "accounts#show", as: "account"
  get "edit_account", to: "accounts#edit", as: "edit_account"
  match "accounts", to: "accounts#update", via: :post

  get "notifications", to: "notifications#index", as: "notifications"
  match "notifications", to: "notifications#read", via: :post

  root "static#home"
end
