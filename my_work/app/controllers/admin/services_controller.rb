class Admin::ServicesController < ApplicationController

  require_role "service"

  def index
    @services = Service.paginate(:all, :page => params[:page], :per_page => 10)
  end

  def update
    service = Service.find(params[:id])
    service.update_attribute(:is_active, !service.is_active)
    render :text => service.is_active ? "Yes" : "No"
  end

end
