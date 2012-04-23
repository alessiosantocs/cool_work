class VenueController < ApplicationController
  include Countries
  layout "application", :except => [:autocomplete, :create]
  before_filter :verify, :only => [:show]
	before_filter :login_required, :except => [:show]

  def initialize
    super
    @menu_section = "party"
  end

  def create
    @countries = all_in_array
    case request.method
      when :post
        @venue = Venue.blank(params[:venue])
        @venue.user_id = session[:user][:id]
        if @venue.save
          ajax_response "{id: #{@venue.id}, name: '#{@venue.name}'};", true
        else
          ajax_response @venue.errors.full_messages.join('. ')
        end
      when :get
        @venue = Venue.blank
        render :layout => "slim"
    end
  end

  def edit
    @countries = all_in_array
  end

  def show
    respond_to do |wants|
      wants.html do 
    		@breadcrumb.drop_crumb("Parties", party_home_url)
    		@breadcrumb.drop_crumb("#{@venue.name}")
    		@page_title << " #{@venue.name} (#{@venue.city_name}, #{@venue.state})"
        @show_map = true
        add2ads "120x600_ros"
        render :layout => 'venue'
      end
      wants.js  { render :inline => @venue.to_json }
    end
  end
  
  def autocomplete
    error_exists = false
    error_text = ""
    if params[:venue][:name].nil?
      error_text = "No Query variable"
      error_exists = true
    end
    if params[:relation].nil?
      error_text = "No Relation variable"
      error_exists = true
    end
    unless error_exists
      q = params[:venue][:name].downcase.strip.gsub('the ','')
      relation = params[:relation].strip
    else
      ajax_response error_text
      return
    end
    query_hash = { :conditions => ["name"], :show => ["name", "address", "city_name", "state"], :order => "name, created_on" }
    query_condition = query_hash[:conditions].collect{|field| "LOWER(#{field}) LIKE \"%#{q}%\" " }.join(" OR ")
    find_options = {
      :select => "id, CONCAT_WS(', ', name,city_name,state) as name",
      :conditions => query_condition,
      :order => query_hash[:order],
      :limit => 10 }
    @items = Venue.find(:all, find_options)
    query_hash[:show] << "id" #added id to be passed through callback function
    ajax_response "<%= auto_complete_result_with_callback @items, " + query_hash[:show].to_json + ", '#{relation}' %>", true
  end
  
  private  
  def verify
    @venue_id = params[:id].to_i
    begin
      @venue = Venue.find @venue_id
    rescue ActiveRecord::RecordNotFound
      flash['bad'] = "Venue not found."
      redirect_back_or_default home_url
      return
    end
  end
end
