class Admin::ContentPromotionsController < ApplicationController
  # GET /admin_content_promotions
  # GET /admin_content_promotions.xml
  def index
    @content_promotions = ContentPromotion.find(:all, :order => "updated_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_promotions }
    end
  end

  # GET /admin_content_promotions/1
  # GET /admin_content_promotions/1.xml
  def show
    @content_promotion = ContentPromotion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content_promotion }
    end
  end

  # GET /admin_content_promotions/new
  # GET /admin_content_promotions/new.xml
  def new
    @content_promotion = ContentPromotion.new
    render :layout => false
#     respond_to do |format|
#       format.html # new.html.erb
#       format.xml  { render :xml => @content_promotion }
#     end
  end

  # GET /admin_content_promotions/1/edit
  def edit
    @content_promotion = ContentPromotion.find(params[:id])
    render :layout => false
  end

  # POST /admin_content_promotions
  # POST /admin_content_promotions.xml
  def create
    @content_promotion = ContentPromotion.new(params[:content_promotion])
    promotion = Promotion.find(params[:content_promotion][:promotion_id])
    @content_promotion.expiry_date = (@content_promotion.expiry_date>promotion.expiry)? promotion.expiry : @content_promotion.expiry_date
    if @content_promotion.save
      flash[:notice] = 'Promotion was successfully created.'
      redirect_to "/admin/content_promotions"
    else
      flash[:error] = 'There is some error occurs.'
      render :action => "new"
    end
  end

  # PUT /admin_content_promotions/1
  # PUT /admin_content_promotions/1.xml
  def update
    @content_promotion = ContentPromotion.find(params[:id])
    if @content_promotion.update_attributes(params[:content_promotion])
      promotion = Promotion.find(params[:content_promotion][:promotion_id])
      @content_promotion.expiry_date = (@content_promotion.expiry_date>promotion.expiry)? promotion.expiry : @content_promotion.expiry_date
      @content_promotion.save!
      flash[:notice] = 'Promotion was successfully updated.'
      redirect_to "/admin/content_promotions"
    else
      flash[:error] = 'There is some error occurs.'
      render :action => "edit"
    end
  end

  # DELETE /admin_content_promotions/1
  # DELETE /admin_content_promotions/1.xml
  def destroy
    @content_promotion = ContentPromotion.find(params[:id])
    @content_promotion.destroy

    respond_to do |format|
      format.html { redirect_to(admin_content_promotions_url) }
      format.xml  { head :ok }
    end
  end

  def send_to_each_user
    users = User.find(:all)
    promotion_content = ContentPromotion.find(params[:id])
    unless users.blank?
      users.each do |user|
        customer = user.customer
        Notifier.deliver_send_promotion( user, promotion_content ) if ( !customer.blank? && customer.customer_preferences.promotion_email ) || user.user_class == 'employee' || user.user_class == 'admin'
      end
    end
    redirect_to admin_content_promotions_path
  end

  def send_mailer_test
    users = User.find(:all, :conditions => "user_class = 'admin'")
    promotion_content = ContentPromotion.find(params[:id])
    users.each do |user|
      Notifier.deliver_send_promotion( user, promotion_content )
    end
    redirect_to admin_content_promotions_path
  end
end
