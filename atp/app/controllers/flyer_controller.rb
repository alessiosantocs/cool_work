class FlyerController < ApplicationController
  layout "editor", :except => [:js, :ad, :drop]
  skip_before_filter :site_data, :only => [:js, :ad]
  before_filter :promoter_required, :except => [:js, :ad]
	before_filter :verify_party, :only => [:manage, :drop, :upload]
	#caches_action :js
  helper ImageHelper
  
	
	def initialize
		super
		@menu_section = "party"
	end
  
  def manage
		@breadcrumb.drop_crumb("Parties", party_home_url)
    @breadcrumb.drop_crumb("Manage", party_manage_url)
    @breadcrumb.drop_crumb("Flyer")
    if request.post?
      @flyer = Flyer.blank(params[:flyer])
      case @flyer.obj_type
        when 'Event'
          @flyer.obj_id = @party.event.id
          @party.event.flyer.destroy() unless @party.event.flyer.nil?
        when 'Party'
          @flyer.obj_id = @party.id
          @party.flyer.destroy() unless @party.flyer.nil?
        else
          flash[:bad] = "Flyer type not selected."
          redirect_to :back
          return
      end
      # drop all old flyers
      
      if @flyer.save
        flash[:good] = "New flyer added."
      else
        flash[:bad] = "No flyer added."
      end
    else
      @flyer = Flyer.blank
    end
  end
	
	def drop
		obj_type = params[:obj_type].to_s
    unless @event.nil?
      unless @party.event.flyer.nil?
        @party.event.flyer.destroy()
        flash[:good] = "Flyer is deleted."
      end
    else
      unless @party.flyer.nil?
        @party.flyer.destroy()
        flash[:good] = "Flyer is deleted."
      end
    end
    redirect_to flyer_manage_url(:id=> @party.id)
	end
  
  def upload
		errors = []
    if request.post?
      images = %r/jpg|jpeg|png/i
      file = params[:file][:images]
      # create image directory path
      img_path = SETTING['image_server']['path']+"/flyer/" # create image directory path
      img_base_url = SETTING['image_server']['base_url']+"/flyer/"
      FileUtils.mkdir_p(img_path)
      if file.content_type.chomp =~ images
        f = file.path
        @image = Image.store(f, 'Flyer', img_path, img_base_url, session[:user][:id])
				unless @image.class.to_s == 'Image'
				  errors << @image
				end
        
        if errors.length == 0
          @flyer = Flyer.new
          @flyer.image_id = @image.id
          case params[:type].to_s
            when 'Event'
              @flyer.obj_id = @party.event.id
              @flyer.obj_type = "Event"
              @party.event.flyer.destroy() unless @party.event.flyer.nil?
            when 'Party'
              @flyer.obj_id = @party.id
              @flyer.obj_type = "Party"
              @party.flyer.destroy() unless @party.flyer.nil?
            else
              flash[:bad] = "No type selected."
          end
          
          unless @flyer.obj_id.nil?
            if @flyer.save
              flash[:good] = "New flyer added."
            else
              flash[:bad] = "No flyer added."
            end
          end
        else
					flash[:bad] = errors.join('. ')
				end
				redirect_to flyer_manage_url(:id=> @party.id)				
      end
    else
      redirect_to flyer_manage_url(:id=> @party.id)
    end
  end
  
  def js
    @flyers = []
    return if params[:city].nil?
    limit = (params[:n].to_i === 1..5 ? params[:n].to_i : 3)
    @flyers = Party.find(:all, :conditions => ["venues.city_id in (?) AND parties_sites.site_id = ? AND parties.active=1 AND flyers.days_left > 0", params[:city], SITE_ID ], :limit => limit, :include => [:venue, :flyer, :sites] )
    @orient = (params[:orient].to_s == 'h' ? 'h' : 'v')
  end 
  alias :ad :js
  
  private
	def verify_party
		begin
			@party = Party.find params[:id].to_i
			if changeable?(@party, session[:user][:id] ) or @party.photographer?(session[:user][:email])
  			@event = @party.events.find params[:event_id].to_i if params[:event_id]
  		else
  			flash['bad'] = "Party not found."
  			redirect_back_or_default :action=>"index"
  			return
  		end
		rescue ActiveRecord::RecordNotFound
			flash['bad'] = "Party not found."
			redirect_back_or_default :action=>"index"
			return
		end
	end
end