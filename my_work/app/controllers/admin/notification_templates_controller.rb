class Admin::NotificationTemplatesController < ApplicationController
  require_role "content"
  
  # GET /notification_templates
  # GET /notification_templates.xml
  def index
    @notification_templates = NotificationTemplate.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notification_templates }
    end
  end

  # GET /notification_templates/new
  # GET /notification_templates/new.xml
  def new
    @notification_template = NotificationTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notification_template }
    end
  end
  
  # GET /notification_templates/1
  # GET /notification_templates/1.xml
  def show
    @notification_template = NotificationTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notification_template }
    end
  end
  
  # GET /notification_templates/1/edit
  def edit
    @notification_template = NotificationTemplate.find(params[:id])
  end

  # POST /notification_templates
  # POST /notification_templates.xml
  def create
    @notification_template = NotificationTemplate.new(params[:notification_template])
    if @notification_template.save
      flash[:notice] = 'NotificationTemplate was successfully created.'
      redirect_to admin_notification_templates_path
    else
      render :action => "new"
    end
  end

  # PUT /notification_templates/1
  # PUT /notification_templates/1.xml
  def update
    @notification_template = NotificationTemplate.find(params[:id])

    respond_to do |format|
      if @notification_template.update_attributes(params[:notification_template])
        flash[:notice] = 'NotificationTemplate was successfully updated.'
        format.html { redirect_to(admin_notification_templates_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notification_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notification_templates/1
  # DELETE /notification_templates/1.xml
  def destroy
    @notification_template = NotificationTemplate.find(params[:id])
    @notification_template.destroy

    respond_to do |format|
      format.html { redirect_to(admin_notification_templates_url) }
      format.xml  { head :ok }
    end
  end
end
