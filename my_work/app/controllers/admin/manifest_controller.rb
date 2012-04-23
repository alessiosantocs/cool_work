class Admin::ManifestController < ApplicationController
  require_role "manifest", :only => [:index]
  before_filter :set_calendar_day, :except => [:assign_truck]
  before_filter :set_zips, :only => [:index, :assign_truck]
  before_filter :set_trucks, :only => [:index, :assign_truck]
  def index
    @serviced_zips = ServicedZip.find(:all, :order => :zip)
    @selected_serviced_zips = ServicedZip.find_all_available_by_selection(session[:selected_zips] )
    @trucks = Truck.find_all_available
    @selected_trucks = Truck.find_all_available_by_selection(session[:selected_trucks])
    @windows = Window.find_all_regular
  end

  def truck_manifest
    @serviced_zips = ServicedZip.find(:all, :order => :zip)
    @truck = Truck.find(params[:id])
    @windows = Window.find_all_regular
    
    render :layout => 'manifest'
  end

  def customer_summary
    @serviced_zips = ServicedZip.find(:all, :order => :zip)
    @truck = Truck.find(params[:id])
    @windows = Window.find_all_regular
    
    render :layout => 'manifest'
  end
  
  
  def assign_truck
    request = Request.find(params[:id].split("_")[1].to_i)
    truck = Truck.find(params[:drop_id].split("_")[1].to_i)
    
    request.make_assignment(truck, nil)
    
    @serviced_zips = ServicedZip.find(:all, :order => :zip)
    @selected_serviced_zips = ServicedZip.find_all_available_by_selection(session[:selected_zips] )
    @trucks = Truck.find_all_available
    @selected_trucks = Truck.find_all_available_by_selection(session[:selected_trucks] )
    @windows = Window.find_all_regular
    
    respond_to do |format|
      format.js  do
        render :update do |page| 
          page.replace_html "manifest", :partial => 'manifest_table'
        end  
      end
    end
  end
  
  def unassign_truck
    request = Request.find(params[:id].split("_")[1].to_i)
    request.assignment.destroy if request.assignment
    
    @serviced_zips = ServicedZip.find(:all, :order => :zip)
    @selected_serviced_zips = ServicedZip.find_all_available_by_selection(session[:selected_zips] )
    @trucks = Truck.find_all_available
    @selected_trucks = Truck.find_all_available_by_selection(session[:selected_trucks] )
    @windows = Window.find_all_regular
    
    respond_to do |format|
      format.js  do
        render :update do |page| 
          page.replace_html "manifest", :partial => 'manifest_table'
        end  
      end
    end
  end

  def order
    current_truck = params[:current_truck_id]
    truck = Truck.find(current_truck)
    if params["truck_" + current_truck.to_s]
      params["truck_" + current_truck.to_s].each_with_index do |id,idx| 
        request = Request.find(id)
        if request && request.assignment
          assignment =  request.assignment
          assignment.position = idx + 1
          assignment.truck_id = current_truck
          assignment.save(false)
        end
      end
    end
    
    render :nothing => true
  end
  private
  def set_calendar_day(date=params[:date])
    date = date.nil? ? (session[:calendar_day].nil? ? Time.now.to_date : session[:calendar_day]) : date.to_date
    session[:calendar_day] = date
  rescue Exception
    session[:calendar_day] = Time.now.to_date
    flash[:error] = "Invalid date"
  end

  def set_trucks(trucks=params[:trucks])
    trucks = trucks.nil? ? (session[:selected_trucks].nil? ? trucks : session[:selected_trucks]) : trucks
    session[:selected_trucks] = trucks
  end
  
  def set_zips(zips=params[:zips])
    session[:selected_zips] = zips
  end
end
