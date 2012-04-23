ActionController::Routing::Routes.draw do |map|  
  #start old paths
  map.connect 'privacy.php', :controller => "page", :action=> "privacy"
  map.connect 'login/*path', :controller => "missing_page", :action=> "login"
  map.connect 'signup', :controller => "missing_page", :action=> "signup"
  map.connect 'pictures/view/:party_id/:obj_id/*path', :controller => "missing_page", :action=> "old_event_images", :party_id => nil, :obj_id => nil
  map.connect 'producer/:user_id', :controller => "missing_page", :action=> "producer", :user_id => nil, :requirements => { :user_id => /\d+/ }
  map.connect 'profile/:username', :controller => "missing_page", :action=> "producer", :username => nil
  map.connect 'system/*path', :controller => 'missing_page', :action => 'image'
  map.connect 'i/*path', :controller => 'missing_page', :action => 'image'
  map.connect '1/*path', :controller => 'missing_page', :action => 'image'
  map.connect 'style/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'buy/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'func/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'talk/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'services/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'js/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'tickets.php', :controller => "missing_page", :action=> "old"
  map.connect '_vti_bin/*path', :controller => 'missing_page', :action => 'scanner'
  map.connect 'MSOffice/*path', :controller => 'missing_page', :action => 'scanner'
  map.connect 'news/*path', :controller => 'missing_page', :action => 'news'
  map.connect 'doubleclick/*path', :controller => 'missing_page', :action => 'old'
  map.connect 'venue/:country/*path', :controller => 'missing_page', :action => 'venue', :country => nil, :requirements => { :country => /[A-Za-z]{2}/ }
  map.connect 'index.rdf', :controller => 'missing_page', :action => 'old'
  map.connect 'archives/*path', :controller => 'missing_page', :action => 'old'
  #end old paths
  
  map.log_stats 'l', :controller=> 'audit', :action=> 'post'
  
  map.with_options :controller => "sitemaps" do |sitemap|
    sitemap.index 'sitemaps.xml', :action => 'index'
  end
  
  map.with_options :controller => "party_sitemap" do |sitemap|
    sitemap.index 'party/sitemap.xml', :action => 'index'
  end

  map.with_options :controller => "venue_sitemap" do |sitemap|
    sitemap.index 'venue/sitemap.xml', :action => 'index'
  end
	
	#people
	map.with_options :controller => 'people' do |m|
		m.people          'people/:username/:action',   :action => 'show'
		m.people_action   'people/:action',             :action=> nil
	end
	
  #msgs
	map.with_options :controller => 'msg' do |m|
		m.msg_create  'msg/create',             :action => 'create'
		m.msg_list    'msg/list', :action=> 'list'
		m.msg_show    'msg/show', :action=> 'show'
	end
	
	#flyers
	map.with_options :controller => 'flyer' do |f|
		f.flyer_ad        'flyer/js',                       :action => 'js'
		f.flyer_manage    'flyer/manage/:id/:event_id',     :action=> 'manage', :id=> nil, :event_id => nil
		f.flyer_connect   'flyer/:action/:id/:event_id',    :action=> nil, :id=> nil, :event_id => nil
	end
	
	#flag
	map.with_options :controller => 'flag' do |t|
		t.flag        'flag/:action/:obj_type/:obj_id',   :requirements => { :obj_type => /[A-Za-z]+/, :obj_id => /\d+/ }
		t.flag_list_update 'flag/update_list',            :action => 'update_list'
	end
	
	#faves
	map.with_options :controller => 'fave' do |t|
		t.fave        'fave/:action/:obj_type/:obj_id',   :requirements => { :obj_type => /[A-Za-z]+/, :obj_id => /\d+/ }
	end
	
	#tags
	map.with_options :controller => 'tag' do |t|
		t.tag_create        'tag/new/:obj_type/:obj_id',    :action => 'new', :requirements => { :obj_type => /[A-Za-z]+/, :obj_id => /\d+/ }
	end
	
	#votes
	map.with_options :controller => 'vote' do |v|
		v.vote_for        'vote/:obj_type/:obj_id/for',        :action => 'tally', :vote => '1'
		v.vote_against    'vote/:obj_type/:obj_id/against',    :action => 'tally', :vote => '0'
	end
	
	#comments
	map.with_options :controller => 'comment' do |c|
		c.comment_new     'comment/new/:obj_type/:obj_id',    :action => 'new'
		c.comment_show    'comment/show/:id',    :action => 'show', :id => nil
		c.comment_update  'comment/update/:id',    :action => 'update', :id => nil
		c.comment_image_set  'comment/show_image_set_for_comment/:id',    :action => 'show_image_set_for_comment', :id => nil
	end
	
	#orders
	map.with_options :controller => 'order' do |order|
		order.order_history   'order/history/:party/:event',   :action => 'history'
		order.order_a_party   'order/party/:id',     :action => 'party', :requirements => { :id => /\d+/ }
	end
	
	#rating
	map.rate 'rate/:obj_type/:obj_id/:rating', :controller=> 'rating', :action=> 'rate', :requirements => { :obj_type => /[A-Za-z]+/, :obj_id => /\d+/ }
	
	#regions
	map.region_choose 'region/show', :controller => "region", :action=> "choose"
	
 	#account
	map.with_options :controller => 'account' do |acct|
		acct.account_create       'account/create',                :action=> 'create'
		acct.reset_password       'account/reset_password/:id/:key',       :action=> 'reset_password'
		acct.account_login        'account/login',                 :action=> 'login'
		acct.account_logout       'account/logout',                :action=> 'logout'
		acct.account_manage       'account/manage',                :action=> 'manage', :sub_action=> nil, :id => nil
		acct.account_update       'account/update/:sub_action',    :action => 'update', :id => nil, :requirements => { :sub_action => /[A-Za-z_]+/ }
		acct.connect              'account/:action/:sub_action',   :id => nil, :requirements => { :sub_action => /[A-Za-z_]+/ }
	end
	
	#image_set
	map.with_options :controller => 'image_set' do |i|
    i.all_images      'pictures',                                  :action => 'index'
    i.all_images_rss  'pictures/rss',                              :action => 'rss'
    i.images_by_day   'pictures/:year/:month/:day',                :action => 'find_by_date', :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
    i.images_by_month 'pictures/:year/:month',                     :action => 'find_by_date', :requirements => { :year => /\d{4}/, :month => /\d{1,2}/ }
    i.image_set       'pictures/:obj_type/:obj_id',                :action => 'show', :id => nil, :requirements => { :obj_id => /\d+/, :obj_type => /[A-Za-z]+/ }
    i.image_single    'pictures/:obj_type/:obj_id/:id',            :action => 'single', :requirements => { :obj_id => /\d+/, :id => /\d+/ }
    i.image_action    'pictures/:obj_type/:obj_id/:id/:action',    :action => nil, :requirements => { :obj_id => /\d+/, :id => /\d+/ }
    i.connect         'pictures/:obj_type/:obj_id/:action',        :action => nil
	end
	
	#venues
	map.with_options :controller => 'venue' do |v|
		v.venue_create   'venue/create', :action=> 'create'
		v.venue_update   'venue/update', :action=> 'update', :id => nil
  	v.connect   'venue/autocomplete', :action=> 'autocomplete'
		v.venue     'venue/:id',    :action=> 'show', :id=>nil
	end
	
	#redirect
	map.with_options :controller => 'redirect' do |r|
		r.redirect   'r/:action/:obj_type/:obj_id',        :action => nil
	end
	
	#event
	map.with_options :controller => 'event' do |r|
		r.event   'event/:id/:action',        :action => nil, :id => nil
	end
	
	#parties
	map.with_options :controller => 'party' do |par|
		par.event_image_set_upload      'party/:id/pictures',             :action => 'pictures', :requirements => { :id => /\d+/ }
		par.party_home                  'parties',                        :action => 'index'
		par.party_home_rss              'parties/rss',                    :action => 'rss'
		par.party_manage                'party/manage',                   :action=> "manage"                                                                           
		par.party_edit                  'party/:id/update',               :action=> "update", :requirements => { :id => /\d+/ }                                        
		par.event_image_set             'party/:id/:event_id/:action',    :requirements => { :id => /\d+/, :event_id => /\d+/ }                                        
		par.event_image                 'party/:id/:event_id/:image_id',  :action => 'image', :requirements => { :id => /\d+/, :event_id => /\d+/, :image_id => /\d+/ }
		par.party_create                'party/create',                   :action=> 'create'
		par.rsvp                        'rsvp/:id',                       :action => 'rsvp', :id => nil
		par.party                       'party/:id',                      :action=> 'show', :id=>nil                                                                   
	end
	
	map.resources :locations
	
	#admin
	map.admin 'admin/:action/:id',   :controller => 'admin', :action => nil, :id => nil
	map.home '', :controller => "search", :action=> "index", :conditions => { :subdomain => /^www?/ }
	map.home '', :controller => "region", :action=> "show"
	map.connect ':controller/:id/:sub_id/:action', :requirements => { :id => /\d+/, :sub_id => /\d+/ }
	map.connect ':controller/:id/:sub_id', :action => 'show', :requirements => { :id => /\d+/, :sub_id => /\d+/ }
	map.connect ':controller/:id/:action', :requirements => { :id => /\d+/ }
	map.connect ':controller/', :action => 'index', :id => nil
	map.connect ':controller/:action', :id => nil
	map.connect ':controller/:id', :action => 'show', :requirements => { :id => /\d+/ }
	map.connect ':controller/:id/:action/:sub_action', :requirements => { :id => /\d+/ }
	map.connect ':controller/:action/:id', :id => nil
	map.connect '*path', :controller => 'four_oh_fours'
end