class DraftCompaniesController < ApplicationController
  # GET /draft_companies
  # GET /draft_companies.xml
  def index
    @draft_companies = DraftCompany.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @draft_companies }
    end
  end

  # GET /draft_companies/1
  # GET /draft_companies/1.xml
  def show
    @draft_company = DraftCompany.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @draft_company }
    end
  end

  # GET /draft_companies/new
  # GET /draft_companies/new.xml
  def new
    @draft_company = DraftCompany.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @draft_company }
    end
  end

  # GET /draft_companies/1/edit
  def edit
    @draft_company = DraftCompany.find(params[:id])
  end

  # POST /draft_companies
  # POST /draft_companies.xml
  def create
    @draft_company = DraftCompany.new(params[:draft_company])

    respond_to do |format|
      if @draft_company.save
        flash[:notice] = 'DraftCompany was successfully created.'
        format.html { redirect_to(@draft_company) }
        format.xml  { render :xml => @draft_company, :status => :created, :location => @draft_company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @draft_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /draft_companies/1
  # PUT /draft_companies/1.xml
  def update
    @draft_company = DraftCompany.find(params[:id])

    draft_review_info=@draft_company.draft_review
    email_tracker_info=draft_review_info.email_tracker
    CustomMessage.deliver_send_alert_mail_to_return_email(email_tracker_info.return_email)
    respond_to do |format|
      if @draft_company.update_attributes(params[:company])
        flash[:notice] = 'DraftCompany was successfully updated.'
     
        format.xml 
      else
 
        format.xml  { render :xml => @draft_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /draft_companies/1
  # DELETE /draft_companies/1.xml
  def destroy
    @draft_company = DraftCompany.find(params[:id])
    @draft_company.destroy

    respond_to do |format|
      format.html { redirect_to(draft_companies_url) }
      format.xml  { head :ok }
    end
  end
end
