class Admin::PromotionServicesController < ApplicationController
  require_role "content"#, :except => [:index]
  # GET /admin_promotion_services
  # GET /admin_promotion_services.xml
  def index
    @promotion_services = PromotionService.find(:all, :conditions => ["promotion_id = ?", params[:promotion_id]])
  end

  # GET /admin_promotion_services/1
  # GET /admin_promotion_services/1.xml
  def show
    @promotion_service = PromotionService.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promotion_service }
    end
  end

  # GET /admin_promotion_services/new
  # GET /admin_promotion_services/new.xml
  def new
    @promotion_service = PromotionService.new
    @service = Service.find(:all)
    @item_types = @service[0].applicable_item_types

    render :layout => false
  end

  def update_sub_categories
    # update sub_categories based on category selected
    service = Service.find(params[:service_id])
    item_types = service.applicable_item_types
   
    render :update do |page|
      page.replace_html params[:update], :partial => 'item_types', :object => item_types, :locals => {:f=> params[:type_id]}
    end
  end
  # GET /admin_promotion_services/1/edit
  def edit
    @promotion_service = PromotionService.find(params[:id])
  end

  # POST /admin_promotion_services
  # POST /admin_promotion_services.xml
  def create
    @promotion_service = PromotionService.new(params[:promotion_service])
    @promotion_service.promotion_id = params[:promotion_id]

    respond_to do |format|
      if @promotion_service.save
        flash[:notice] = 'Service bind to Promotion successfully.'
        format.html { redirect_to admin_promotion_promotion_services_path(params[:promotion_id]) }
        format.xml  { render :xml => @promotion_service, :status => :created, :location => @promotion_service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @promotion_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_promotion_services/1
  # PUT /admin_promotion_services/1.xml
  def update
    @promotion_service = PromotionService.find(params[:id])

    respond_to do |format|
      if @promotion_service.update_attributes(params[:promotion_service])
        flash[:notice] = 'Promotion was successfully updated.'
        format.html { redirect_to admin_promotion_promotion_services_path(params[:promotion_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @promotion_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_promotion_services/1
  # DELETE /admin_promotion_services/1.xml
  def destroy
    @promotion_service = PromotionService.find(params[:id])
    @promotion_service.destroy
    redirect_to admin_promotion_promotion_services_path

  end
end
