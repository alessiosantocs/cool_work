class EmailTrackersController < ApplicationController
  require 'uuidtools' 
  uses_tiny_mce
  # GET /email_trackers
  # GET /email_trackers.xml
  def index
    @email_trackers = EmailTracker.find(:all).sort_by{|p| p.created_at}.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_trackers }
    end
  end

  # GET /email_trackers/1
  # GET /email_trackers/1.xml
  def show
    @email_tracker = EmailTracker.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email_tracker }
    end
  end

  # GET /email_trackers/new
  # GET /email_trackers/new.xml
  def new
    @email_tracker = EmailTracker.new
    @tracker_id = params[:tracker_id]
    @all_template=EmailTemplate.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email_tracker }
    end
  end

  # GET /email_trackers/1/edit
  def edit
    @email_tracker = EmailTracker.find(params[:id])
  end

  # POST /email_trackers
  # POST /email_trackers.xml
  # POST /email_trackers
  # POST /email_trackers.xml
  def create
	if(params[:tracker_id] != "")
		logger.info("traker id is not an empty string: "+params[:tracker_id])
		@message_trackers = MessageTracker.find(:all,:conditions => ["answered = ? and email_tracker_id = ?",0,params[:tracker_id]])
		@companies = Array.new
		logger.info("about to print message.id")
		@message_trackers.each do |message_tracker|
			logger.info(message_tracker["company_id"])
			@companies.push(Company.find(message_tracker["company_id"]))
		end
	else 
		@companies = Company.find(:all, :conditions => ["enabled = ?",1])
	end 

        params[:email_tracker]=params

        @email_tracker = EmailTracker.new()
        @email_tracker[:message]=params[:email_tracker][:message_body]
	@email_tracker[:subject]=params[:email_tracker][:message_subject]
        @email_tracker[:return_email]=params[:email_tracker][:message_return]
	emailTSave = false
	if @email_tracker.save
	   emailTSave = true
	end
	@companies.each do |company|
#		uuid = UUID.new
		uuid = UUIDTools::UUID.timestamp_create

		@people = Personnel.find(:all, :conditions => ["company_id = ?",company["id"]])
		@people.each do |person|
			messageSentSuccess = false 
			unless person["email"].blank?

				message = params[:email_tracker][:message_body]
				message = message.gsub("[[first_name]]",person["first_name"])
				message = message.gsub("[[last_name]]",person["last_name"])
				message = message.gsub("[[company_name]]",company["name"])

				message = message.gsub("[[return_email]]",@email_tracker["return_email"])
				urlKey = uuid.to_s
				urlLink = "http://www.health2advisors.com/companies/show?key="+urlKey
				message = message.gsub("[[link_company_profile]]",urlLink)
				CustomMessage.deliver_send_message_to_company(person.email,@email_tracker["return_email"],params[:email_tracker][:message_subject],message)
				@mTracker = MessageTracker.new({"email_tracker_id" => @email_tracker["id"],"company_id" => company["id"],"answered" => false,"url_key" => urlKey})
				@mTracker.save()
			end 
		end 
		
	end 
    respond_to do |format|
      if emailTSave
        flash[:notice] = 'Email Messages were successfully sent.'
        format.html { redirect_to(@email_tracker) }
        format.xml  { render :xml => @email_tracker, :status => :created, :location => @email_tracker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_tracker.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /email_trackers/1
  # PUT /email_trackers/1.xml
  def update
    @email_tracker = EmailTracker.find(params[:id])

    respond_to do |format|
      if @email_tracker.update_attributes(params[:email_tracker])
        flash[:notice] = 'EmailTracker was successfully updated.'
        format.html { redirect_to(@email_tracker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /email_trackers/1
  # DELETE /email_trackers/1.xml
  def destroy
    @email_tracker = EmailTracker.find(params[:id])
    @email_tracker.destroy

    respond_to do |format|
      format.html { redirect_to(email_trackers_url) }
      format.xml  { head :ok }
    end
  end

 def send_mail_to_all_person_of_company
   email = params[:email_tracker]
   @email_tracker = EmailTracker.new()
   @email_tracker[:message]=email[:message]
   @email_tracker[:subject]=email[:subject]
   @email_tracker[:return_email]=email[:return_email]
   @email_tracker.save
   uuid = UUIDTools::UUID.timestamp_create
   company=Company.find(:first,:conditions =>["id = ?",email[:company_id]])
   personnels = company.personnels
   personnels.each do|person|
	unless person.email.blank?

		message = @email_tracker.message
		message = message.gsub("[[first_name]]",person.first_name)
		message = message.gsub("[[last_name]]",person.last_name)
		message = message.gsub("[[company_name]]",company.name)
		message = message.gsub("[[return_email]]",@email_tracker.return_email)
		urlKey = uuid.to_s
		urlLink = "http://www.health2advisors.com/companies/show?key="+urlKey
		message = message.gsub("[[link_company_profile]]",urlLink)
		CustomMessage.deliver_send_mail_to_all_person_of_company(person.email, email[:return_email], email[:subject], message)
		@mTracker = MessageTracker.new({"email_tracker_id" => @email_tracker.id,"company_id" => email[:company_id],"answered" => false,"url_key" => urlKey})
		@mTracker.save
	end 	
   end
  redirect_to :action=>"show",:controller=>"companies", :id=>params[:email_tracker][:company_id]  
 end 

    def preview_email_page
        unless params[:id]==nil
          @all_template=EmailTemplate.find(params[:id])
          @body_message=@all_template[:template_data]
        else
             @body_message=params[:message_body]
        end
            render:layout=>false
        
    end

  def template_data_take
     @all_template=EmailTemplate.new()
     @all_template[:template_name]=params[:template][:name]
     @all_template[:template_data]=params[:template][:data]
     @all_template.save
     respond_to do |format|
       format.xml  { render :xml => @all_template}
     end

  end

  def give_all_template
    @all_template=EmailTemplate.all
    respond_to do |format|
        format.xml  { render :xml => @all_template }
        end
  end

    def destroy_template
      @all_template = EmailTemplate.find(params[:id])
      @all_template.destroy
        respond_to do |format|
        format.xml  { render :xml => @all_template }
        end
    end

    def template_update
       @all_template=EmailTemplate.find(params[:id])
       @all_template[:template_name]=params[:template][:name]
       @all_template[:template_data]=params[:template][:data]
       @all_template.save
        respond_to do |format|
        format.xml  { render :xml => @all_template }
        end
    end
   
    def give_body_for_template
       @all_template=EmailTemplate.find(params[:id])
        respond_to do |format|
        format.xml  { render :xml => @all_template }
        end
    end

    def show_send_mail
        @email_tracker = EmailTracker.new
        @all_template=EmailTemplate.all
        render :layout=>false
    end
    
    
end