class StopsController < ApplicationController
  require_role "scheduling"
  
  # GET /stops/new
  # GET /stops/new.xml
  def new
    @stop = Stop.new()
    if params[:date]
      @stop.date = params[:date].to_date
      @stop.location_id = params[:loc]
      @stop.window_id = params[:win]
      if @stop.save
        flash[:notice] = 'Stop was successfully created.'
        redirect_to('/admin/schedule')
      end
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @stop }
        format.js   { render :action => "new.html.erb", :layout => false }
      end
    end
  end
  
  # GET /stops/1/edit
  def edit
    @stop = Stop.find(params[:id])
    
    @assignment = Assignment.new()
    @assignment.date = @stop.date
    @assignment.location_id = @stop.location_id 
    @drivers = Driver.find(:all)
    @trucks = Truck.find(:all)
    
    respond_to do |format|
      format.html # new.html.erb
      format.js   { render :action => "edit.html.erb", :layout => false }
    end
  end
  
  # POST /stops
  # POST /stops.xml
  def create
    @stop = Stop.new(params[:stop])
    
    respond_to do |format|
      if @stop.save
        flash[:notice] = 'Stop was successfully created.'
        format.html { redirect_to('/admin/schedule') }
        format.xml  { render :xml => @stop, :status => :created, :location => @stop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stop.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /stops/1
  # PUT /stops/1.xml
  def update
    @stop = Stop.find(params[:id])
    #    truck = Truck.find(params[:assignment][:truck])
    #    driver = Driver.find(params[:assignment][:driver])
    
    respond_to do |format|
      if @stop.update_attributes(params[:stop])
        #        if params['stop_assignment'] == 'on'
        #          Assignment.reserve(params[:assignment][:date], truck, driver, params[:assignment][:location_id])
        #        end
        flash[:notice] = 'Stop was successfully updated.'
        format.html { redirect_to('/admin/schedule') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stop.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /stops/1
  # DELETE /stops/1.xml
  def destroy
    @stop = Stop.find(params[:id])
    @stop.destroy
    
    respond_to do |format|
      format.html { format.html { redirect_to('/admin/schedule') } }
      format.xml  { head :ok }
    end
  end
  
  def add_slot
    @stop = Stop.find(params[:id])
    @stop.add_slot
    @stop.save!
    
    respond_to do |format|
      format.html { format.html { redirect_to('/admin/schedule') } }
      format.js {
        render :update do |page|
          page.replace_html "slots_stop_#{@stop.id}", @stop.slots.to_s
          page.replace_html "slots_left_#{@stop.id}", @stop.slots_left.to_s
        end
      }
      format.xml  { head :ok }
    end
  end
  
  def remove_slot
    @stop = Stop.find(params[:id])
    @stop.remove_slot(1)
    @stop.save!
    
    respond_to do |format|
      format.html { format.html { redirect_to('/admin/schedule') } }
      format.js {
        if @stop.closed?
          render :update do |page|
            page.replace_html "window_stop_#{@stop.id}", :partial => 'closed', :locals => {:stop => @stop}
          end
        elsif @stop.error?
          render :update do |page|
            page.replace_html "window_stop_#{@stop.id}", :partial => 'error', :locals => {:stop => @stop}
          end
        else
          render :update do |page|
            page.replace_html "slots_stop_#{@stop.id}", @stop.slots.to_s
            page.replace_html "slots_left_#{@stop.id}", @stop.slots_left.to_s
          end
        end
      }
      format.xml  { head :ok }
    end
  end
  
end
