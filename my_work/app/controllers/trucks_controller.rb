class TrucksController < ApplicationController
  before_filter :admin_required
  
  # GET /trucks/new
  # GET /trucks/new.xml
  def new
    @truck = Truck.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @truck }
      format.js   { render :action => "new.html.erb", :layout => false }
    end
  end
  
  # GET /trucks/1/edit
  def edit
    @truck = Truck.find(params[:id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.js   { render :action => "edit.html.erb", :layout => false }
    end
  end
  
  # POST /trucks
  # POST /trucks.xml
  def create
    @truck = Truck.new(params[:truck])
    if @truck.save
      flash[:notice] = 'Truck was successfully created.'
      redirect_to :back
    else
      render :action => "new"
    end
  end
  
  # PUT /trucks/1
  # PUT /trucks/1.xml
  def update
    @truck = Truck.find(params[:id])
    if @truck.update_attributes(params[:truck])
      flash[:notice] = 'Truck was successfully updated.'
      redirect_to :back
    else
      render :action => "edit"
    end
  end
  
  # DELETE /trucks/1
  # DELETE /trucks/1.xml
  def destroy
    @truck = Truck.find(params[:id])
    @truck.destroy
    
    respond_to do |format|
      flash[:notice] = 'Truck was successfully deleted.'
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end
