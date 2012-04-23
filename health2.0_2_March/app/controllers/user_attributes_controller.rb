class UserAttributesController < ApplicationController
  before_filter :require_user, :only => [:index,:show, :new, :destroy, :update]
  # GET /user_attributes
  # GET /user_attributes.xml
  def index
    @user_attributes = UserAttribute.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_attributes }
    end
  end

  # GET /user_attributes/1
  # GET /user_attributes/1.xml
  def show
    @user_attribute = UserAttribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_attribute }
    end
  end

  # GET /user_attributes/new
  # GET /user_attributes/new.xml
  def new
    @user_attribute = UserAttribute.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_attribute }
    end
  end

  # GET /user_attributes/1/edit
  def edit
    @user_attribute = UserAttribute.find(params[:id])
  end

  # POST /user_attributes
  # POST /user_attributes.xml
  def create
    #@user_attribute = UserAttribute.new(params[:user_attribute])
	user = User.find(:all, :conditions => "login = '" + params["user_attribute"]["User"] + "'")
	
	logger.info(user.id.to_s)
	att  = params["user_attribute"]["name"]
	#existCheck = Users.find({"user" => user, "name" => attribute)
	#count = UserAttribute.count(:conditions => "user_id == " + user.id.to_s + " AND name== "+ attribute)
	#if count == 0:	
		logger.info(user[0])
		logger.info("info out")
		@user_attribute = UserAttribute.new({"User"=> user[0], "name" => att})
		@user_attribute.save
	#end 
    
    respond_to do |format|
      if @user_attribute.save
        flash[:notice] = 'UserAttribute was successfully created.'
        format.html { redirect_to(@user_attribute) }
        format.xml  { render :xml => @user_attribute, :status => :created, :location => @user_attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_attributes/1
  # PUT /user_attributes/1.xml
  def update
    @user_attribute = UserAttribute.find(params[:id])

    respond_to do |format|
      if @user_attribute.update_attributes(params[:user_attribute])
        flash[:notice] = 'UserAttribute was successfully updated.'
        format.html { redirect_to(@user_attribute) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_attributes/1
  # DELETE /user_attributes/1.xml
  def destroy
    @user_attribute = UserAttribute.find(params[:id])
    @user_attribute.destroy

    respond_to do |format|
      format.html { redirect_to(user_attributes_url) }
      format.xml  { head :ok }
    end
  end
  
  def find_by_user
 	@user_attributes = CompanyCategory.find(:all, :conditions => ["user_id = ?", params[:user_id]])
	respond_to do |format|
    		format.xml  { render :xml => @user_attributes }
    end
  end 
  
  
end
