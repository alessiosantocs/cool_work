ActionController::Routing::Routes.draw do |map|


  map.resources :pwd_trackers

  map.connect "draft_reviews/:action", :controller =>'draft_reviews', :action =>/[a-z_]+/i
  map.resources :draft_reviews

  map.connect "draft_products/:action", :controller =>'draft_products', :action =>/[a-z_]+/i
  map.resources :draft_products

  map.connect "draft_partnerships/:action", :controller =>'draft_partnerships', :action =>/[a-z_]+/i
  map.resources :draft_partnerships

  map.connect "draft_personnels/:action", :controller =>'draft_personnels', :action =>/[a-z_]+/i
  map.resources :draft_personnels

  map.connect "draft_partnerships/:action", :controller =>'draft_partnerships', :action =>/[a-z_]+/i
  map.resources :draft_partnerships

  map.connect "draft_investments/:action", :controller =>'draft_investments', :action =>/[a-z_]+/i
  map.resources :draft_investments

  map.connect "draft_company_categories/:action", :controller =>'draft_company_categories', :action =>/[a-z_]+/i
  map.resources :draft_company_categories

  map.connect "draft_companies/:action", :controller =>'draft_companies', :action =>/[a-z_]+/i
  map.resources :draft_companies

  map.connect "csv_files/:action", :controller =>'csv_files', :action =>/[a-z_]+/i
  map.resources :csv_files

  map.connect "users/:action", :controller =>'users', :action =>/[a-z_]+/i
  map.resources :users

    
 map.resources :email_template ,:collection=>{:give_all_template=>:get,:template_update=>:put,:destroy_template=>:get,:give_body_for_template=>:get,:template_data_take=>:post,:add_template=>:get},:member=>{:edit_template=>:get}
 
 map.resources :companies ,:collection=>{:edit_basic_information=>:get,:listCompanies=>:get,:find_by_start_part=>:get,:find_by_company_name=>:get,:get_company_list=>:get,:add_people=>:get,:internal_show=>:get,:update_internal_only=>:get,:desc_order_by_last_update=>:get,:asc_order_by_last_update=>:get,:asc_order_by_name=>:get,:desc_order_by_name=>:get,:send_email_to_company=>:post,:dateCompaniesCreated=>:get,:show_for_send_mail=>:get}

  map.resources :personnels ,:collection=>{:find_by_company=>:get,:find_by_name=>:get,:add_people=>:get,:destroy_item=>:get}

  map.resources :email_trackers ,:collection=>{:give_all_template=>:get,:template_update=>:put,:destroy_template=>:get,:give_body_for_template=>:get,:send_mail_to_all_person_of_company=>:get,:show_send_mail=>:get}

   map.resources :company_categories ,:collection=>{:find_by_companies=>:get,:find_by_name=>:get,:return_category_names=>:get,:destroy_item=>:get,:find_by_category=>:get,:find_by_company=>:get,:show_segment=>:get ,:updateCategoryForCompany=>:get}

    
    map.connect "categories/:action", :controller =>'categories', :action =>/[a-z_]+/i
  map.resources :categories

  map.resources :references ,:collection=>{:find_by_company=>:get,:add_references=>:get,:destroy_item=>:get}


  map.resources :products ,:collection=>{:find_by_company=>:get,:add_products=>:get,:destroy_item=>:get}
 

  map.resources :partnerships ,:collection=>{:find_by_company=>:get,:add_partnerships=>:get,:destroy_item=>:get}

  map.resources :investments ,:collection=>{:find_by_company=>:get,:add_investments=>:get,:destroy_item=>:get}  

  
  map.resources :keyword_stores ,:collection=>{:find_by_company=>:get,:modify_keyword=>:get,:destroy_item=>:get,:updateByCompany=>:put} 


  map.resources :videos ,:collection=>{:find_by_company=>:get,:add_video=>:get,:destroy_item=>:get}  
 
  map.resources :message_trackers

  map.resources :user_attributes
  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  map.root :controller => "user_sessions", :action => "new"
  


 map.connect "search/:action", :controller =>'search', :action =>/[a-z_]+/i
  map.resources :search

 map.connect "single_videos/:action", :controller =>'single_videos', :action =>/[a-z_]+/i
  map.resources :single_videos

 map.connect "payment/:action", :controller =>'payment', :action =>/[a-z_]+/i
  map.resources :payment

  map.connect "phone_numbers/:action", :controller =>'phone_numbers', :action =>/[a-z_]+/i
  map.resources :phone_numbers

  map.connect "email_addresses/:action", :controller =>'email_addresses', :action =>/[a-z_]+/i
  map.resources :email_addresses


  map.connect "email_trackers/:action", :controller =>'email_trackers', :action =>/[a-z_]+/i
  map.connect "message_trackers/:action", :controller =>'email_trackers', :action =>/[a-z_]+/i
  map.resources :message_trackers



  map.connect "people/:action", :controller =>'people', :action =>/[a-z_]+/i
  map.resources :people

  map.connect "profits/:action", :controller =>'profits', :action =>/[a-z_]+/i
  map.resources :profits


  map.root :controller => "home"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


  
  
end
