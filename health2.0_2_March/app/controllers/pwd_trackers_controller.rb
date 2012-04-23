class PwdTrackersController < ApplicationController
  # GET /pwd_trackers
  # GET /pwd_trackers.xml
  def index
    @pwd_trackers = PwdTracker.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pwd_trackers }
    end
  end

  # GET /pwd_trackers/1
  # GET /pwd_trackers/1.xml
  def show
    @pwd_tracker = PwdTracker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pwd_tracker }
    end
  end

  # GET /pwd_trackers/new
  # GET /pwd_trackers/new.xml
  def new
    @pwd_tracker = PwdTracker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pwd_tracker }
    end
  end

  # GET /pwd_trackers/1/edit
  def edit
    @pwd_tracker = PwdTracker.find(params[:id])
  end

  # POST /pwd_trackers
  # POST /pwd_trackers.xml
  def create
    @pwd_tracker = PwdTracker.new(params[:pwd_tracker])

    respond_to do |format|
      if @pwd_tracker.save
        flash[:notice] = 'PwdTracker was successfully created.'
        format.html { redirect_to(@pwd_tracker) }
        format.xml  { render :xml => @pwd_tracker, :status => :created, :location => @pwd_tracker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pwd_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pwd_trackers/1
  # PUT /pwd_trackers/1.xml
  def update
    @pwd_tracker = PwdTracker.find(params[:id])

    respond_to do |format|
      if @pwd_tracker.update_attributes(params[:pwd_tracker])
        flash[:notice] = 'PwdTracker was successfully updated.'
        format.html { redirect_to(@pwd_tracker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pwd_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pwd_trackers/1
  # DELETE /pwd_trackers/1.xml
  def destroy
    @pwd_tracker = PwdTracker.find(params[:id])
    @pwd_tracker.destroy

    respond_to do |format|
      format.html { redirect_to(pwd_trackers_url) }
      format.xml  { head :ok }
    end
  end
end
