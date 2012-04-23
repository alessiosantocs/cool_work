require 'net/http'
require 'json'
require 'youtube_g'
require 'hpricot'


class VideosController < ApplicationController
  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    type = params[:type]
    url =  params[:swf]
    url = url.tr_s(",","&")
    logger.info(type)
    if type == "youtube"
	leftIndex = url.rindex("/")
	rightIndex = url.index("&")
	videoID = url[leftIndex,rightIndex]
	thumbnailURL = "http://img.youtube.com/vi/"+videoID+"/default.jpg"
	@video = Video.new({"type" => type,"company_id" => params[:company_id],"swf" => url, "height" => params[:height],"width" => params[:width], "thumbnail" => thumbnailURL, "videoID" => videoID })
	puts "hello from youtube"
	@video.save
	logger.info("from youtube if else in video controller")
    end
    if type == "vimeo"

	leftIndex = url.find("clip_id")
	rightIndex = url.find("&",leftIndex)
	videoID = url[leftIndex,rightIndex]
	url = URI.parse('http://www.example.com/index.html')
    	req = Net::HTTP::Get.new(url.path)
    	res = Net::HTTP.start(url.host, url.port) {|http|
     	 http.request(req)
    	}
	vimeoInfo = Hash.from_xml(res)
	thumbnailURL = (vimeoInfo[:videos][:video].last)["thumbnail_small"]

        @video =Video.new({"type" => type,"company_id" => params[:company_id], "swf" => url, "height" => params[:height],"width" => params[:width], "thumbnail" => thumbnailURL, "videoID" => videoID })
	@video.save
    end 

	

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create

    video=params[:video]
    type = params[:vtype]
    url =  video[:swf]
    url = url.gsub(/,,,,,,,,,,/,"=").gsub(/,,,,,/,"&")
    logger.info(type)
    if type == "youtube"
       # leftIndex = url.index("v=")
       # rightIndex = url.index("&")     
       # videoID = url[leftIndex+2,rightIndex-leftIndex-2]
       # logger.info(videoID)
        first_index=url.rindex("/")
        second_index=url.index("v=")
        third_index=url.rindex("&")
        videoID=url[second_index+2,third_index-1]

        swf_url=get_youtube_video_url(url,videoID,first_index)

        #thumbnail = get_youtube_thumbnail(videoID)
        @video = Video.new({"company_id" => video[:company_id],"swf" => swf_url, "height" => video[:height],"width" => video[:width], "video_type" =>type ,"videoID" => videoID})
        @video.save
    end 
    if type == "vimeo"
	swf = url
        leftIndex=url.rindex("/")
        videoID = url[leftIndex+1,url.length]
        #thumbnail = get_vimeo_thumbnail(videoID)
        @video =Video.new({"company_id" => video[:company_id], "swf" => swf, "height" => video[:height],"width" => video[:width],"video_type" =>type, "videoID" => videoID })
        @video.save
    end
    
    if type == "brightcove"
        url_hapricot=Hpricot(url)
        split_array=(url_hapricot).to_s.split("=")
        array_element=split_array[14]
        videoID=array_element[0,array_element.length-9]
        # we convert the returned JSON data to native Ruby
        # data structure - a hash
       @video =Video.new({"company_id" => video[:company_id],"height" => video[:height],"width" => video[:width],"video_type" =>type, "videoID" => videoID })
       @video.save
    end
  
      if @video.save
         redirect_to :action=>"show", :controller=>"companies",:id=>params[:video][:company_id]
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(@video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end


  def find_by_company
        @video = Video.find(:all, :conditions => ["company_id = ?", params[:companyID]])
        respond_to do |format|
                format.xml  { render :xml => @video }
        end
  end

 def destroy_item
   @video = Video.find(params[:id])
   @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end

def add_video
@video=Video.new

render :layout=>false
end
protected 
    def get_youtube_thumbnail(video_id)
        url = "http://gdata.youtube.com/feeds/api/videos/"+video_id+"?v=2"
        respose = Net::HTTP.get_response(URI.parse(url))
        xml_response = Hpricot(respose.body)
        thumb_element =(xml_response/'media:thumbnail').first.to_s.split("=")
        thumb_element_text=thumb_element[2]
        thumbnail=thumb_element_text[1,thumb_element_text.length-9]
        return thumbnail
    rescue Exception => e
        logger.info("Youtube thumbnail parsing error\n\n")
        logger.info(e.to_s)
        return ""
    end

   def get_youtube_video_url(get_url,video_id,index)
        first_url_part=get_url[0,index]
        swf=first_url_part+"/v/"+video_id+"?version=3"
        return swf 
   end
    def get_vimeo_thumbnail(video_id)
        url = "http://vimeo.com/api/v2/video/#{video_id}.xml"
        respose= Net::HTTP.get_response(URI.parse(url))
	logger.info(respose)
        xml_response = Hpricot(respose.body)
        thumb_element=(xml_response/'thumbnail_small').to_s.split(">")
        thumb_element_text=thumb_element[1]
        thumbnail=thumb_element_text[0,thumb_element_text.length-17]
        return thumbnail
    rescue Exception => e
        logger.info("Vimeo thumbnail parsing error\n\n")
        logger.info(e.to_s)
        return ""
    end


end
