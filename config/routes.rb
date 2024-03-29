SCInterface::Application.routes.draw do

  resources :workspace_relationships

  resources :customers
  
  #match 'scratch_user/manage_workspace'   => "calculs#manage_workspace" 
  resources :scratch_user
 
  
  resources :sc_admin_workspace
  resources :sc_admin_company
  resources :sc_admin_application
  resources :sc_admin_user
  resources :sc_admin_bill do
    get 'download_bill'
  end
  
  resources :forfaits
  resources :ecosystem_mecanic
  
  resources :members do
    resources :company
    resources :workspaces
  end
  
  resources :company do
    resources :members
    resources :workspaces
  end
  
  devise_for  :users,   :controllers => { :sessions => "users/sessions", :registrations => "users/registrations", :confirmations => "users/confirmations" , :passwords => "users/passwords"}

  resources :laboratory
  resources :materials
  resources :links
  
  resources :calculs
  match 'calculs/duplicate'   => "calculs#duplicate" 
  
  match 'workspaces/get_gestionnaire'   => "workspaces#get_gestionnaire"  
  match 'workspaces/add_application'   => "workspaces#add_application"  
  resources :workspaces do
    resources :materials
    resources :links
    resources :forfaits
    get 'ecosystem_mecanic', :on => :member
    resources :sc_models do 
      post 'load_mesh', :on => :member
      get 'share', :on => :member
      get 'ecosystem_mecanic', :on => :member
    end
    
    resources :bills do
      get 'download_bill', :on => :member
      get 'cancel', :on => :member
    end
    resources :members
    resources :company
  end
  
  resources :sc_models do 
    resources :calculs
    resources :scult 
    resources :visualisation
  end
  
  


  root :to => "scratch_user#show"

  match ':controller(/:action(/:id(.:format)))'

  # La route par défaut héritée de l'application Rails 2, à conserver avant passage au REST.
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  
  
  
  
  
  
  # -----------------------------------------------------------------------------------------
  # --------------------------------- Commentaires standards --------------------------------
  # -----------------------------------------------------------------------------------------
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"


end
