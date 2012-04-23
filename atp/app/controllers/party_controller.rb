class PartyController < ApplicationController
  session :off, :only => [:rss]
  caches_action :rss
  caches_page :rsvp_form
	before_filter :login_required, :except => [:show, :index, :rss, :rsvp]
	before_filter :verify_party, :only => [:show, :pay, :pictures, :image_set, :image, :update, :js, :rsvp, :rsvp_form]
	helper :image_set, :image
	
	def initialize
		super
		@menu_section = "party"
	end
  
  def rss
    rss = {:title => "Parties from #{SITE.full_name}", :link => "http://www.#{SITE.url}", :cities => CITIES.collect{|c| c[:id]} }
    unless @region_name.nil?
      rss[:title] = "#{@region.full_name} Parties from #{SITE.full_name}"
      rss[:link] = party_home_url
      rss[:cities] = @city_ids
    end
    options = { 
      :feed => {
        :title => rss[:title],
        :link => rss[:link],
        :ttl => 30
        },
        :item => {
          :title => :rss_title,
          :description => :rss_description,
          :pub_date => :created_on
        }
      }
    parties = Party.recent_parties_by_city(rss[:cities], { :limit => 15} )
    render_rss_feed_for(parties,options)
  end
  
  def index
    if @region_name.nil?
      flash[:bad] = "Select a city."
      redirect_to "http://www.#{SITE.url}/"
      return
    end
		@breadcrumb.drop_crumb("Parties")
		@page_title << "#{@region.full_name} Upcoming Parties"
    1.upto(3){|i| add2ads "120x120_parties#{i}" } #inhouse ads for party home page
  end
	
	def show
    if @region_name.nil?
      redirect_to party_url(:host => get_city_short_name(@party.venue.city_id) + ".#{SITE.url}", :id=> @party.id)
      return
    end
		@breadcrumb.drop_crumb("Parties", party_home_url)
		@breadcrumb.drop_crumb("#{@party.venue.name}", venue_url(:id => @party.venue_id))
		@breadcrumb.drop_crumb("#{@party.title}")
		@page_title << " #{@party.title} at #{@party.venue.name} (#{@party.venue.city_name}, #{@party.venue.state})"
		respond_to do |wants|
			wants.html do
			  @show_map = true
        add2ads "120x600_ros"
			  1.upto(3){|i| add2ads "120x120_party#{i}" }
			end
			wants.js  { ajax_response @party.to_json, true }
		end
	end
	
	def rsvp
	  if request.post?
  	  @rsvp = Booking.blank(params[:booking]) rescue Booking.blank
  	  @rsvp.user_id = session[:user][:id] if logged_in?
  	  @rsvp.party_id = @party.id
  	  respond_to do |wants|
  	    #require "ruby-debug"; debugger
    	  if @rsvp.save
        	Notifier::deliver_rsvp_to_promoter(@rsvp, @party)
          wants.js { ajax_response("", true) }
          wants.html do
            if @rsvp.source != "local"
              flash[:good] = "RSVP Successful."
              redirect_to party_url(:host => get_city_short_name(@party.venue.city_id) + ".#{SITE.url}", :id=> @party.id)
            else
              render :inline => "<%= automatic_window_close('RSVP Successful') %>"
            end
          end
    	  else
          wants.js { ajax_response "#{@rsvp.errors.full_messages.join(' ')}" }
          wants.html { render :layout => 'slim' }
    	  end
  	  end
  	else
  	  respond_to do |wants|
        wants.js { render :layout => nil }
        wants.html { render :layout => 'slim' }
      end
  	end
	end
	
	def rsvp_form
	  @source =  (params[:source].nil? ? "email" : params[:source] )
	  ajax_response "<%= rsvp_form(@party,@source) %>", true
	end
	
	def manage
	  if promoter? or photographer?
  		@breadcrumb.drop_crumb("Parties", party_home_url)
  		@breadcrumb.drop_crumb("Manage")
  		params[:active] == 'false' ? active = false : active = true
  		@parties = Party.find(:all, :conditions => ["(parties.user_id=? OR parties.photographer = ?) AND parties.active=?", session[:user][:id], session[:user][:email], active], :order => "events.happens_at desc", :include => [:events])
  	else
  	  flash[:bad] = "You are not a promoter or a photographer."
  	  redirect_to party_home_url
  	end
	end
	
	def image
		@image = @event.image_sets.find(params[:image_id].to_i)
	end
	
	def image_set
		@breadcrumb.drop_crumb("#{@party.title} at #{@party.venue.name}", party_url(:id=>@party.id))
		@breadcrumb.drop_crumb(@event.local_time('date'))
		@images = @event.image_sets
	end
	
	def create
		@breadcrumb.drop_crumb("Parties", party_home_url)
    @breadcrumb.drop_crumb("Manage", party_manage_url)
		@breadcrumb.drop_crumb("Create")
		@page_title << " Create a new party"
		case request.method
  		when :post
  		  party_vars = params[:party].except(:"next_date(1i)", :"next_date(2i)", :"next_date(3i)")
  			@party = Party.blank(party_vars)
  			@party.user_id = self.current_user[:id]
  			if @party.save
  				@party.sites << Site.find(SITE_ID) # associate with current site
  				flash['good'] = "Congrats... Party added."
					redirect_to party_manage_url
  			else
  			  @party.next_date = Time.parse(params[:party][:next_date]) if @party.next_date.is_a?(String)
  				@venue = Venue.blank(params[:venue])
      		render :layout => "editor"
  			end
  		when :get
  			@party = Party.blank
  			@party.next_date  = nil
  			@party.start_time = nil
  			@party.rsvp_email = session[:user][:email]
    		render :layout => "editor"
		end    
	end
	
	def update
		@breadcrumb.drop_crumb("Parties", party_home_url)
    @breadcrumb.drop_crumb("Manage", party_manage_url)
		@breadcrumb.drop_crumb("Update")
		@page_title << " Update #{@party.title}"
		if @party.user_id == self.current_user[:id] or @party.photographer?(self.current_user[:email])
			case request.method
  			when :post
  				if @party.update_attributes(params[:party].except(:"next_date(1i)", :"next_date(2i)", :"next_date(3i)"))
  					flash['good'] = "Congrats... Party updated."
  					FreeOrder.party(@party, session[:user][:id])
						redirect_to party_manage_url(:active => @party.active)
  				else
  				  @party.next_date = Time.parse(params[:party][:next_date]) if @party.next_date.is_a?(String)
  					@venue = Venue.blank(params[:venue])
  					render :layout => "editor"
  				end
  			when :get
  				@party.next_date = @party.event.local_time
  				@party.start_time = @party.event.local_time('12hr')
  				@party.end_time = @party.event.local_time('12hr', @party.length_in_hours.hours.seconds)
  				render :layout => "editor"
			end
		else
			flash[:bad] = "Can't edit this party."
			redirect_to home_url
		end
	end
	
	def pictures
	  if @party.user_id == session[:user][:id] or @party.photographer == session[:user][:email]
  		@breadcrumb.drop_crumb("Parties", party_home_url)
      @breadcrumb.drop_crumb("Manage", party_manage_url)
  		@breadcrumb.drop_crumb("Upload Pictures")
  		@page_title << " Upload pictures for  #{@party.title}"
  		render :layout => 'party'
  	else
  	  flash[:bad] = "Access Denied!"
  	  redirect_to home_url
  	end
	  
	end
	
	private  
	def verify_party
		begin
			@party = Party.find params[:id].to_i
			unless params[:event_id].nil?
				@event = @party.events.find params[:event_id].to_i
			end
		rescue ActiveRecord::RecordNotFound
			flash['bad'] = "Party not found."
			redirect_back_or_default home_url
			return
		end
	end
end