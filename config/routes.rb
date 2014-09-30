BetterMousetrap::Application.routes.draw do
  # get "sessions/index"
  # get "sessions/login"
  # get "sessions/create"
  # get "sessions/destroy"
  resources :sessions

  match "/gadgets/:id/upvote", to: 'gadgets#upvote', via: :post
  match "/gadgets/:id/downvote", to: 'gadgets#downvote', via: :post
  resources :gadgets
  resources :registers

  match '/register', to: 'registers#index', via: :get

  match '/login',  to: 'sessions#login',   via: 'get'
  match '/logon',  to: 'sessions#login',   via: 'get'
  match '/create', to: 'sessions#create',  via: 'post'
  match '/logout', to: 'sessions#destroy', via: 'delete'

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
