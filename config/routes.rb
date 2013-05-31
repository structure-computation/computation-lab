SCInterface::Application.routes.draw do

  resources :workspace_relationships
  resources :customers
  resources :scratch_user
 
  resources :sc_admin_workspace
  resources :sc_admin_company
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
  
  match 'workspaces/get_gestionnaire'   => "workspaces#get_gestionnaire"  
  resources :workspaces do
    resources :forfaits
    get 'ecosystem_mecanic', :on => :member
    
    resources :bills do
      get 'download_bill', :on => :member
      get 'cancel', :on => :member
    end
    resources :members
    resources :company
  end
  
  root :to => "scratch_user#show"

  match ':controller(/:action(/:id(.:format)))'

  # La route par défaut héritée de l'application Rails 2, à conserver avant passage au REST.
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
end
