class ServicedZipsController < ApplicationController
  before_filter :admin_required
  
  # GET /serviced_zips/new
  # GET /serviced_zips/new.xml
  def new
    @serviced_zip = ServicedZip.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @serviced_zip }
      format.js   { render :action => "new.html.erb", :layout => false }
    end
  end
  
  # GET /serviced_zips/1/edit
  def edit
    @serviced_zip = ServicedZip.find(params[:id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.js   { render :action => "edit.html.erb", :layout => false }
    end
  end
  
  # POST /serviced_zips
  # POST /serviced_zips.xml
  def create
    @serviced_zip = ServicedZip.new(params[:serviced_zip])
    if @serviced_zip.save
        flash[:notice] = 'Route was successfully created.'
        redirect_to :back
     else
        render :action => "new"
      end
  end
  
  # PUT /serviced_zips/1
  # PUT /serviced_zips/1.xml
  def update
    @serviced_zip = ServicedZip.find(params[:id])
    if @serviced_zip.update_attributes(params[:serviced_zip])
      flash[:notice] = 'Route was successfully updated.'
      redirect_to :back
    else
      render :action => "edit"
    end
  end
  
  # DELETE /serviced_zips/1
  # DELETE /serviced_zips/1.xml
#  def destroy
#    @serviced_zip = ServicedZip.find(params[:id])
#    @serviced_zip.destroy
#    
#    respond_to do |format|
#      format.html { format.html { redirect_to :back } }
#      format.xml  { head :ok }
#    end
#  end
end
