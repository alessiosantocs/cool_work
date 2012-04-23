class Admin::PromotionsController < ApplicationController
  require_role "content"
  
  def index
    @current_promotions = Promotion.find(:all, :order => "updated_at desc", :conditions => ["expiry >= ?", Date.today.strftime("%Y-%m-%d")])
    @old_promotions = Promotion.find(:all, :order => "updated_at desc", :conditions => ["expiry < ?", Date.today.strftime("%Y-%m-%d")])
    render :template => 'admin/promotions/index'
  end

  def new
    @promotion = Promotion.new
    render :layout => false
  end

  def edit
    @promotion = Promotion.find(params[:id])
    render :layout => false
  end

  def create
    params[:promotion][:times_usable_per_user] = 1 if params[:promotion][:times_usable_per_user] == '' || params[:promotion][:times_usable_per_user] == '0'
    params[:promotion][:times_usable] = 1 if params[:promotion][:times_usable] == '' || params[:promotion][:times_usable] == '0'
    @promotion = Promotion.new(params[:promotion])
    respond_to do |format|
      if @promotion.save
        flash[:notice] = 'Promotion was successfully created.'
        format.html { redirect_to '/admin/promotions' }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @promotion.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @promotion = Promotion.find(params[:id])
    params[:promotion][:times_usable_per_user] = 1 if params[:promotion][:times_usable_per_user] == '' || params[:promotion][:times_usable_per_user] == '0'
    params[:promotion][:times_usable] = 1 if params[:promotion][:times_usable] == '' || params[:promotion][:times_usable] == '0'
    respond_to do |format|
      if @promotion.update_attributes(params[:promotion])
        flash[:notice] = 'Promotion was successfully updated.'
        format.html { redirect_to '/admin/promotions' }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @promotion.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @promotion = Promotion.find(params[:id])
    service_promotions = @promotion.promotion_services
    unless service_promotions.blank?
      service_promotions.each do |service_promotion|
        service_promotion.destroy
      end
    end

    promotions_ads = @promotion.content_promotions
    unless promotions_ads.blank?
      promotions_ads.each do |promotions_ad|
        promotions_ad.destroy
      end
    end
    @promotion.destroy
    
    redirect_to '/admin/promotions'
  end
end
