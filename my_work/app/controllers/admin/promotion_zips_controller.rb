class Admin::PromotionZipsController < ApplicationController
  # GET /admin_promotion_zips
  # GET /admin_promotion_zips.xml
  def index
    @promotion_zips = PromotionZip.find(:all, :conditions => ["promotion_id = ?", params[:promotion_id]])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @promotion_zips }
    end
  end

  # GET /admin_promotion_zips/1
  # GET /admin_promotion_zips/1.xml
  def show
    @promotion_zip = PromotionZip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promotion_zip }
    end
  end

  # GET /admin_promotion_zips/new
  # GET /admin_promotion_zips/new.xml
  def new
    @promotion_zip = PromotionZip.new
    render :layout=>false
  end

  # GET /admin_promotion_zips/1/edit
  def edit
    @promotion_zip = PromotionZip.find(params[:id])
  end

  # POST /admin_promotion_zips
  # POST /admin_promotion_zips.xml
  def create
    @promotion_zip = PromotionZip.new(params[:promotion_zip])
    @promotion_zip.promotion_id = params[:promotion_id]

    respond_to do |format|
      if @promotion_zip.save
        flash[:notice] = "Zip is added to the promotion"
        format.html { redirect_to admin_promotion_promotion_zips_path(params[:promotion_id]) }
        format.xml  { render :xml => @promotion_service, :status => :created, :location => @promotion_service }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @promotion_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_promotion_zips/1
  # PUT /admin_promotion_zips/1.xml
  def update
    @promotion_zip = PromotionZip.find(params[:id])

    respond_to do |format|
      if @promotion_zip.update_attributes(params[:promotion_zip])
        format.html { redirect_to(admin_promotion_promotion_zips_path(params[:promotion_id]), :notice => 'Promotion Zip was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @promotion_zip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_promotion_zips/1
  # DELETE /admin_promotion_zips/1.xml
  def destroy
    @promotion_zip = PromotionZip.find(params[:id])
    @promotion_zip.destroy
    flash[:notice] = "Zip is deleted from promotion"
    redirect_to :back
  end
end
