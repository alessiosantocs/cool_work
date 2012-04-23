ActionController::Routing::Routes.draw do |map|
  # See how all your routes lay out with "rake routes"
  
  
  map.with_options :controller => 'static' do |static|
    static.agreement    '/home',     :action => 'home'
    static.automatic_logout    '/automatic_logout', :action => 'automatic_logout'
    static.agreement    '/agreement',     :action => 'agreement'
    static.about_us     '/about',         :action => 'about'
    static.how_it_works '/how_it_works',  :action => 'how_it_works'
    static.prices       '/prices',        :action => 'prices'
    static.servicearea       '/servicearea',        :action => 'servicearea'
    static.pickup       '/pickup',        :action => 'pickup'
    static.doorman       '/doorman',        :action => 'doorman'
    static.contact_us   '/contact_us',    :action => 'contact_us'
    static.faq   '/faq',    :action => 'faq'
    static.my_environment   '/my_environment',    :action => 'my_environment'
    static.my_fresh_air   '/my_fresh_air',    :action => 'my_fresh_air'
    static.fresh_air   '/fresh_air',    :action => 'fresh_air'
    static.my_fresh_water   '/my_fresh_water',    :action => 'my_fresh_water'
    static.five_points   '/five_points',    :action => 'five_points'
    static.seven_stages   '/seven_stages',    :action => 'seven_stages'
    static.delivery_fees   '/delivery_fees',    :action => 'delivery_fees'
    static.customize_example   '/customize_example',    :action => 'customize_example'
    static.insurance   '/insurance',    :action => 'insurance'
    static.fresh_water   '/fresh_water',    :action => 'fresh_water'
    static.my_ecologic   '/my_ecologic',    :action => 'my_ecologic'
    static.ecologic   '/ecologic',    :action => 'ecologic'
    static.my_order   '/my_order',    :action => 'my_order'
    static.my_schedule   '/my_schedule',    :action => 'my_schedule'
    static.my_payment   '/my_payment',    :action => 'my_payment'
    static.our_cleaning   '/our_cleaning',    :action => 'our_cleaning'
    static.ordering_process   '/ordering_process',    :action => 'ordering_process'
    static.promotions   '/fresh_promotions',    :action => 'fresh_promotions'
    static.logreg   '/logreg',    :action => 'logreg'
    static.send_message   '/send_message',    :action => 'send_message', :method => 'post'
    static.current_news   '/current_news',    :action => 'news'
    static.eco_point '/eco_point', :action => 'eco_point'
  end
  
  # Routes for admin workflow
  map.namespace :admin do |admin|
    admin.root :controller => 'base'
    admin.resources :customers
    admin.resources :employees
    admin.resources :accounts
    admin.resources :notification_templates
    admin.resources :intakes, :member => {:ticket => :get, :tickets => :get, :sort => :get, :quick_sort => :get, :quick_sort_and_verify => :post, :finalize_order => :post}
    #admin.resources :terminal, :member => {:login => :get, :scan => :get, :scanned => :get}
    admin.terminal "terminal/:area/:action/:id", :controller => 'sort'
    admin.resources :services do |services|
        services.resources :prices
    end
    admin.resources :promotions do |promotion|
          promotion.resources :promotion_services
          promotion.resources :promotion_zips
    end
    admin.resources :content_promotions, :member => { :send_to_each_user => :get, :send_mailer_test => :get }
    admin.monthwise_category_report "/reporting/monthwise_category_report", :controller => 'reporting', :action => 'monthwise_category_report', :conditions => { :method => :get }
    admin.monthwise_item_type_report "/reporting/monthwise_item_type_report", :controller => 'reporting', :action => 'monthwise_item_type_report', :conditions => { :method => :get }
    admin.monthwise_customer_report "/reporting/monthwise_customer_report", :controller => 'reporting', :action => 'monthwise_customer_report'
    admin.monthwise_customer_report "/reporting/monthwise_promotion_report", :controller => 'reporting', :action => 'monthwise_promotion_report'
    admin.selected_monthwise_category_report "/reporting/selected_monthwise_category_report", :controller => 'reporting', :action => 'selected_monthwise_category_report'
    admin.selected_monthwise_item_type_report "/reporting/selected_monthwise_item_type_report", :controller => 'reporting', :action => 'selected_monthwise_item_type_report'
    admin.selected_monthwise_customer_report "/reporting/selected_monthwise_customer_report", :controller => 'reporting', :action => 'selected_monthwise_customer_report'
    admin.selected_monthwise_customer_report "/reporting/selected_monthwise_promotion_report", :controller => 'reporting', :action => 'selected_monthwise_promotion_report'
  end

  #map.resources :customers
  map.resources :news, :tickers
  map.resources :order_items, :member =>{ :edit_extra_charge => :get, :update_extra_charge => :put }
 
  # Routes for driver workflow
  map.namespace :driver do |driver|
    driver.root :controller => 'base'
  end
  
  # Routes for warehouse workflow
  map.namespace :warehouse do |warehouse|
    warehouse.root :controller => 'base'
  end
  
  # Serviced Zips, Trucks
  map.resources :serviced_zips, :trucks
  map.resources :state
  #Stops
  map.resources :stops, :member => {:add_slot => :post, :remove_slot => :post }  
  
  # Customers
  map.resources :customers, :member => { :preference_choice => :get, :update_recurring => :post, :fresh_order => :get, :preferences => :get, :ecologic => :get, :buy_credit => :post, :dashboard => :get, :create_order => :post , :invitations => :get, :request_invitations => :get,:delete_recurring => :delete,:edit_recurring=>:get,:update_recurring_order=>:post,:redeem => :post } do |customers|
    customers.resources :orders, :member => { :schedule => :get, :reschedule => :get, :make_request => :post, :confirm => :post, :make_payment => :post, :completion => :get, :thanks => :get, :receipt => :get, :payment => :get }
    customers.admin_schedule "/admin_schedule", :controller => 'orders', :action => 'admin_schedule'
    customers.admin_make_request "/admin_make_request", :controller => 'orders', :action => 'admin_make_request'
    customers.resources :credit_cards
  end
  map.resources :notes
  map.resources :customer_preferences
  map.resources :invitations
  
  # Login/logout/signup routes
  map.resource :session
  map.resources :passwords 
  map.resources :users
  map.signup    '/signup/:invitation_token', :controller => 'customers', :action => 'new'
  map.signup    '/signup', :controller => 'customers', :action => 'new'
  map.login     '/login', :controller => 'sessions', :action => 'new'
  map.logout    '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password    '/forgot_password', :controller => 'passwords', :action => 'new'
  map.auto_logout    '/auto_logout', :controller => 'sessions', :action => 'auto_logout'
  
  map.unsubscribe_promotion '/customer_preferences/:customer_id/unsubscribe_promotion', :controller => 'customer_preferences', :action => 'unsubscribe_promotion'

  # Homepage maps to base/index
  map.root :controller => 'static', :action => 'home'
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
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
  
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
end
