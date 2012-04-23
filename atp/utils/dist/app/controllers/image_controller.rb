include Util
class ImageController < Merb::Controller
  before :validate_user
  
  def index
    @args = params
    render_no_layout
  end 
  
  def upload
  	@errors = []
  	last_position = 0
  	if request.post?
  		images = %r/jpg|jpeg|png/i
  		file = params[:data][:tempfile].path
  		event_id = params[:id]
  		@event = Event.find event_id
  		@party = @event.party
  		last_position = @event.image_sets.size
  		if @event.picture_uploaded or @party.pics_left > 0
  		  @event.set_uploaded(@user.id) unless @event.picture_uploaded # deduct a picture set if no pic not uploaded
  
  			img_path = SETTING['image_server']['merb_path']+"/party/#{@party.id}/#{@event.id}/" # create image directory path
  			img_base_url = SETTING['image_server']['base_url']+"/party/#{@party.id}/#{@event.id}/"
  			FileUtils.mkdir_p(img_path)
  				
  			if params[:data][:type] =~ images
  				f = file
  				@image = Image.process_for_storage(f, 'Event', img_path, img_base_url, @user.id)
  				if @image.class.to_s == 'Image'
    				last_position += 1
    				add_image_to_image_set(@image, last_position)
  				else
  				  @errors << @image
  				end
  			else
  			  #puts params[:data].inspect
  				fc = FileCollection.new(file, params[:data][:filename].sub(/.*?((\.tar)?\.\w+)$/, '\1') )
  				fc.process
  				fc.find(images).each do |f|
  					@image = Image.process_for_storage(f, 'Event', img_path, img_base_url, @user.id)
  					if @image.class.to_s == 'Image'
      				last_position += 1
      				add_image_to_image_set(@image, last_position)
  					else
  					  @errors << @image
  					end
  				end
  				fc.delete
  			end
  			@event.update_image_set_count
    		unless @errors.empty?
        	#puts "pic errors"
    		  render_js "picture_error"
    		else
        	#puts "no pic errors"
        	render_no_layout
    		end
  		else
      	#puts "no_more_pictures"
  		  render_js "no_more_pictures"
  		  return
  		end
  	else
    	#puts "get meth"
  	  render_no_layout
  	end
  end
  
  def progress
    Mongrel::Uploads.debug = true
    @upstatus = Mongrel::Uploads.check(params[:upload_id])
    render_js 'progress'
  end
  
	private
	def add_image_to_image_set(image, position)
	  #puts image.inspect
		@event.image_sets.create({
			:image_id => image.id,
			:comments_allowed => image.comments_allowed,
			:position => position
		})
	end
end