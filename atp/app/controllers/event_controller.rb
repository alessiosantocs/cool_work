class EventController < ApplicationController
  before_filter :login_required, :except => [:picture]
  before_filter :verify_event, :only => [:index, :update, :upload, :update_image_sets]
  helper ImageSetHelper
  
  def initialize
    super
    @page_title = String.new
    @breadcrumb = Breadcrumb.new
  end
  
  def index
    respond_to do |wants|
      wants.html { redirect_to image_set_url(:obj_type => 'event', :obj_id => @event.id) }
      wants.js { ajax_response @event.to_json, true }
    end
  end
  
  def update
    if changeable?(@event.party, session[:user][:id]) or @event.access?(session[:user][:id], session[:user][:email])
      if @event.update_attributes(params[:event])
        msg = ["Event Updated.", true]
      else
        msg = ["Event Not Updated. #{@event.errors.full_messages.join('. ')}", false]
      end
      respond_to do |wants|
        wants.html { msg[1] == true ? flash['good'] = msg : flash['bad'] = msg }
        wants.js { ajax_response msg[0], msg[1] }
      end
    else
      msg = "Event Not Updated. You don't have access to this event."
      respond_to do |wants|
        wants.html { 
          flash[:bad] = msg
          event_image_set_upload_url({ :id => @event.party_id,:event_id => @event.id})
        }
        wants.js { ajax_response msg }
      end
    end
  end
    
  def upload
	  if @event.party.past_events.empty?
	    flash[:bad] = "No past events exist yet."
	    redirect_to party_manage_url
	    return false
	  end
		errors = []
		last_postition = 0
		if request.post?
			images = %r/jpg|jpeg|png/i
			file = params[:file]
			last_postition = @event.image_sets.length
			if @event.picture_uploaded  == true or @event.party.pics_left > 0
			  @event.set_uploaded(session[:user][:id]) unless @event.picture_uploaded == true # deduct a picture set if no pic not uploaded

  			img_path = SETTING['image_server']['path']+"/party/#{@event.party_id}/#{@event.id}/" # create image directory path
  			img_base_url = SETTING['image_server']['base_url']+"/party/#{@event.party_id}/#{@event.id}/"
  			FileUtils.mkdir_p(img_path)
  			
  			if file.respond_to?(:content_type) and file.content_type.chomp =~ images
  				f = file.path
  				@image = Image.store(f, 'Event', img_path, img_base_url, self.current_user[:id])
					if @image.class.to_s == 'Image'
    				last_postition += 1
    				add_image_to_image_set(@image, last_postition)
  				  @event.update_image_set_count
  				  flash[:good] = 'Picture uploaded and processed.'
					else
					  errors << @image
					  flash[:bad] = errors.join('. ')
					end
  			else
  			  #put in image_queue
  			  bg_task = @event.addToQueue(file, self.current_user[:id]) #bg_task_id returned
  			  session[:bg_task_id] = bg_task.id
  			  flash[:good] = "The file is uploaded. You will be notified when the process is done."
  			end
				redirect_to event_image_set_upload_url({ :id => @event.party_id,:event_id => @event.id})
  		end
		end
  end
  
  private  
  def verify_event
    @event_id = params[:id].to_i
    begin
      @event = Event.find @event_id
    rescue ActiveRecord::RecordNotFound
      ajax_response "Event not found."
      return
    end
  end

	def add_image_to_image_set(image, position)
		@event.image_sets.create({
			:image_id => image.id,
			:comments_allowed => image.comments_allowed,
			:position => position
		})
	end
end