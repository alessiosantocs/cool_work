class ImageSetController < ApplicationController
  session :off, :only => [:rss]
  caches_action :rss
	before_filter :login_required, :except => [:index, :find_by_date, :rss]
	before_filter :objs_required, :except => [:index, :find_by_date, :rss]
	before_filter :pull_object_data, :only => [:show, :single]
	helper ImageHelper, PartyHelper
	
	def initialize
		super
		@menu_section = "image"
	end
	
  def index
    if @region_name.nil?
      flash[:bad] = "Select a city."
      redirect_to "http://www.#{SITE.url}/"
      return
    end
  	@breadcrumb.drop_crumb("Pictures")
  	@page_title << "Latest #{@region.full_name} Pictures"
  end
  
  def rss
    latest_pictures = Event.latest_image_sets(@city_ids, {:limit => 15})
    options = { 
      :feed => {
        :title => "The Latest #{@region.full_name} Pictures from #{SITE.full_name}",
        :link => all_images_url,
        :ttl => 30
        },
        :item => {
          :title => :rss_title,
          :description => :synopsis,
          :pub_date => :picture_upload_time
        }
      }
    render_rss_feed_for(latest_pictures,options)
  end
  
  def find_by_date
    @breadcrumb.drop_crumb("Pictures", all_images_url)
    @breadcrumb.drop_crumb("Find By Date")
    @this_date = Time.utc(params[:year],params[:month],params[:day])
  	@page_title << "Pictures from " + @this_date.strftime("%a, %b %d %y")
  end

	def show
    respond_to do |wants|
      wants.html do
        @breadcrumb.drop_crumb(@event_date)
        add2ads "120x600_ros"
        1.upto(3){|i| add2ads "120x120_party#{i}" }
      end
      wants.js  { ajax_response "<%= show_pictures(@images) -%>", true }
    end
	end
	
	def single
	  @image = @obj_rec.image_sets.find_by_id params[:id].to_i
	  if @image.nil?
	    redirect_to all_images_path
	    flash[:bad] = "This image has been deleted or doesn't exist"
	    return
	  else
    	@breadcrumb.drop_crumb(@event_date, image_set_url(:obj_type => @obj_type, :obj_id => @obj_id))
    	@breadcrumb.drop_crumb(@image.position)
    	@page_title << " :: " +  @image.position.to_s
      respond_to do |wants|
        wants.html do
          add2ads "120x120_ros"
          add2ads "120x600_ros"
          add2ads "336x280_ros"
          render :template => "image_set/single" 
        end
        wants.js  { ajax_response "<%= show_pictures(@image) -%>", true }
      end
    end
	end
	alias :undefined :single
	
  def order
		list = params['image_set'].to_a
		@pictures = @obj_rec.image_sets
		for pic in @pictures
			pos = list.rindex("#{pic.id.to_i}").to_i + 1
			pic.update_attribute(:position,pos) if pos != pic.position
		end
		ajax_response("The order is updated.", true)
	end
	
  def update_images
		deleted = params['delete']
		captions = params['caption']
		comments_allowed = params['comments_allowed']
		pictures = @obj_rec.image_sets
		for pic in pictures
		  if deleted[pic.id.to_s] == '1'
		    pic.destroy
	    else
			  pic.image.update_attributes({ :caption => captions[pic.id.to_s], :comments_allowed => comments_allowed[pic.id.to_s] })
			end
		end
    flash[:good] = "Images Updated."
  	redirect_to event_image_set_upload_url({ :id => @obj_rec.party_id,:event_id => @obj_rec.id})
  end
  
	def update_caption
		id = params[:id].to_i
		caption = params[:caption] || params[:value]
		case @obj_type
		  when 'Event'
		    party = @obj_rec.party
		    picture = ImageSet.find(:first, :conditions => [ "id=?", id]) if changeable?(party, session[:user][:id] ) or party.photographer?(session[:user][:email])
		   else
		    picture = nil
		end
		unless picture.nil?
		  picture.image.update_attribute(:caption, caption.to_s)
  		ajax_response(caption.to_s, true)
  		return
  	end
		ajax_response("The image is NOT updated.")
	end
	
	def drop
		id = params[:id].to_i
		case @obj_type
		  when 'Event'
		    party = @obj_rec.party
		    if changeable?(party, session[:user][:id] ) or party.photographer?(session[:user][:email])
		      picture = ImageSet.find(:first, :conditions => [ "id=?", id])
		    end
		   else
		    picture = nil
		end
		unless picture.nil?
		  if picture.drop
  			ajax_response("return true;", true)
  			return
  		end
  	end
		ajax_response("The image is NOT deleted.")
	end
  
	def js
	  case @obj_type
	    when "Event"
    		#get event info and image_set
    		@rec = { :party => PartyPublic.new(@obj_rec.party), :event => EventPublic.new(@obj_rec) }
    		ajax_response "img_info=<%= @rec.to_json %>", true
    	else
    	 ajax_response "#{@obj_type} currently not being served."
	  end
	end
	
	private
	def pull_object_data
  	@breadcrumb.drop_crumb("Pictures", all_images_url)
	  case @obj_type
	    when "Event"
	      title = "#{@obj_rec.party.title} at #{@obj_rec.venue.name}"
    		@breadcrumb.drop_crumb(title, party_url(:id=>@obj_rec.party_id))
    		@page_title << title
    		@picture_title = "#{@obj_rec.party.title} at #{@obj_rec.venue.name}"
    		@obj_type = "event"
    	else
    	 ajax_response "#{@obj_type} currently not being served."
    	 return
	  end	  
	  @images = @obj_rec.image_sets
	  @obj_type = @obj_type.downcase
	  @event_date = @obj_rec.local_time('date')
	  @page_title << " :: #{@event_date}"
	end
end