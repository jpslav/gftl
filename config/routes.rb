Gftl2::Application.routes.draw do

  devise_for :users

  resources :race_stables
  resources :preseason_rankings
  resources :race_pairings
  resources :race_results
  resources :draft_lists
  resources :help
  resources :cars
  resources :tracks
  resources :races do
    delete :destroy_stables, :on => :member
  end
  resources :league_memberships
  resources :owners
  resources :leagues
  resources :rules
  
  match 'league_memberships/play/:id' => 'league_memberships#play', :as => 'play_membership'
  match 'league_details/' => 'league_details#index', :as => 'league_details'

  match "leagues/email_standings"
  match "leagues/email_everyone"
  match "race_stables/run_weekly_draft"
  match "race_stables/email_weekly_draft_results"

  match "league_memberships/select_draft_list" => 'league_memberships#select_draft_list'
  match 'league_memberships/select_darkhorse' => 'league_memberships#select_darkhorse'
  
  match "race_results/pick_cars/:id" => "race_results#pick_cars"
  match "race_results/import_results_cars/:id" => "race_results#import_results"
  match "race_results/add_cars" => "race_results#add_cars"
  match "race_results/parse_results_table"
  get "race_results/destroy_by_race"
  get "race_results/set_race_result_points_delta"  
  
  # For on-the-spot...
  resources :race_results do
    collection do
      post :update_attribute_on_the_spot
    end
  end
  
  # For draft list sorting:
  resources :draft_lists do
    post :sort, :on => :collection
  end
  
  match "draft_lists/show_hover_drivers" => "draft_lists#show_hover_drivers"
  
  # For preseason ranking sorting:
  resources :preseason_rankings do
    post :sort, :on => :collection
  end
  
  resources :users, :only => [:index, :show, :edit, :update] do
    post 'become'
  end
  
  
  root :to => "home#index"
  
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

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
