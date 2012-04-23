class SingleVideosController < ApplicationController
  # GET /single_videos
  # GET /single_videos.xml
  def index
    @single_videos = SingleVideo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @single_videos }
    end
  end

  # GET /single_videos/1
  # GET /single_videos/1.xml
  def show
    @single_video = SingleVideo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @single_video }
    end
  end

  # GET /single_videos/new
  # GET /single_videos/new.xml
  def new
    @single_video = SingleVideo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @single_video }
    end
  end

  # GET /single_videos/1/edit
  def edit
    @single_video = SingleVideo.find(params[:id])
  end

  # POST /single_videos
  # POST /single_videos.xml
  def create
    @single_video = SingleVideo.new(params[:single_video])

    respond_to do |format|
      if @single_video.save
        flash[:notice] = 'SingleVideo was successfully created.'
        format.html { redirect_to(@single_video) }
        format.xml  { render :xml => @single_video, :status => :created, :location => @single_video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @single_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /single_videos/1
  # PUT /single_videos/1.xml
  def update
    @single_video = SingleVideo.find(params[:id])

    respond_to do |format|
      if @single_video.update_attributes(params[:single_video])
        flash[:notice] = 'SingleVideo was successfully updated.'
        format.html { redirect_to(@single_video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @single_video.errors, :status => :unprocessable_entity }
      end
    end
  end


  def find_by_company
        @single_video= SingleVideo.find(:all, :conditions => ["company_id = ?", params[:company_id]])
        respond_to do |format|
                format.xml  { render :xml => @single_video }
        end
  end




  # DELETE /single_videos/1
  # DELETE /single_videos/1.xml
  def destroy
    @single_video = SingleVideo.find(params[:id])
    @single_video.destroy

    respond_to do |format|
      format.html { redirect_to(single_videos_url) }
      format.xml  { head :ok }
    end
  end




end
