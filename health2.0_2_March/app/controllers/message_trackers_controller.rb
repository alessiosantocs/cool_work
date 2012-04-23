class MessageTrackersController < ApplicationController
  # GET /message_trackers
  # GET /message_trackers.xml
  def index
    @message_trackers = MessageTracker.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_trackers }
    end
  end

  # GET /message_trackers/1
  # GET /message_trackers/1.xml
  def show
    @message_tracker = MessageTracker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_tracker }
    end
  end

  # GET /message_trackers/new
  # GET /message_trackers/new.xml
  def new
    @message_tracker = MessageTracker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_tracker }
    end
  end

  # GET /message_trackers/1/edit
  def edit
    @message_tracker = MessageTracker.find(params[:id])
  end

  # POST /message_trackers
  # POST /message_trackers.xml
  def create
    @message_tracker = MessageTracker.new(params[:message_tracker])

    respond_to do |format|
      if @message_tracker.save
        flash[:notice] = 'MessageTracker was successfully created.'
        format.html { redirect_to(@message_tracker) }
        format.xml  { render :xml => @message_tracker, :status => :created, :location => @message_tracker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_trackers/1
  # PUT /message_trackers/1.xml
  def update
    @message_tracker = MessageTracker.find(params[:id])

    respond_to do |format|
      if @message_tracker.update_attributes(params[:message_tracker])
        flash[:notice] = 'MessageTracker was successfully updated.'
        format.html { redirect_to(@message_tracker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_trackers/1
  # DELETE /message_trackers/1.xml
  def destroy
    @message_tracker = MessageTracker.find(params[:id])
    @message_tracker.destroy

    respond_to do |format|
      format.html { redirect_to(message_trackers_url) }
      format.xml  { head :ok }
    end
  end
end
