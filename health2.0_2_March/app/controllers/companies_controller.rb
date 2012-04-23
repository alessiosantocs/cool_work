class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.xml
  before_filter :require_user, :only => [ :new, :destroy, :update]
  uses_tiny_mce
  require 'uuidtools' 

  
  def index

    testStr = "18902cfc-eb7f-11df-bd7a-0019d12ccfbb"
    logger.info(params[:id])
    if params[:id] == testStr
            @companies = Company.all
            respond_to do |format|
                format.html # index.html.erb
                format.xml  # index.xml.builder
            end

    else
        respond_to do |format|
            format.html # index.html.erb
            format.xml  # index.xml.builder
        end

    end 
  end


 

  def listCompanies 
   
	listOnly = true 
    if current_user
		@subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
		@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
		@a_str = "false"
		if @admin.to_s != "" 
			@a_str = params[:a_str]
			@subscribed = true 
		end
	    listOnly = false 


    end 
    
    if listOnly == true
     sql = ActiveRecord::Base.connection();
     @companies = CompanyQueries.pullAllCompanies
	end 
     respond_to do |format|
      format.html
      format.xml  # index.xml.builder
     end

  end 

 
  def returnShortList
	@companyList = Company.find(:all,:conditions => ['name LIKE ?', '%' + params[:q] + '%'])
	#render :partial => "customers/autocomplete.json"
	@newList = Array.new
	
	for company in @companyList:
		@newList.insert(0,{ "name" => company["name"], "value" => company["id"].to_s})
	end
	respond_to do |format|
      #format.xml 
      format.json { render :json => @newList }
 
    end

  
  end

  def getCompanyNames
	cArr = params[:companyList].split(",")
	sqlStr = ""
	first = true 
	for item in cArr:
		if item.length > 0
			if first
				sqlStr += "id = "+item
				first = false 
			else
				sqlStr += " OR "+ "id = "+item  
			end
			
		end
	end
	
	logger.info(sqlStr)
	@companyList = Company.find(:all,:conditions => [sqlStr])
	#render :partial => "customers/autocomplete.json"
	@newList = Array.new
	
	for company in @companyList:
		@newList.insert(0,{ "name" => company["name"], "value" => company["id"].to_s})
	end
	respond_to do |format|
      #format.xml 
      format.json { render :json => @newList }
 
    end

  
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
  unless params[:key]
   @company_information = Company.find(:first, :conditions => ["id = ?", params[:id]])
   @all_template=EmailTemplate.all
      unless @company_information.blank?
   	@personnels = @company_information.personnels
   	@products = @company_information.products
   	@partnerships = @company_information.partnerships
   	@company_categories = @company_information.company_categories
   	@investments = @company_information.investments
        @videos = @company_information.videos
	@keyword = KeywordStore.find(:first,:conditions => ["company_id = ?", params[:id]])
	@references=Reference.find(:all,:conditions => ["company_id = ?", params[:id]])
   end
 end

    urlKey =  params[:key]
    @notKey = "true" 
    @dID = 0
    if urlKey.to_s != ""
		@message_tracker = MessageTracker.find(:all,:conditions => ["url_key = ?", urlKey])
		if @message_tracker.to_s != ""
			@allMessages = MessageTracker.find(:all, :conditions => ["email_tracker_id = ? and company_id=?",@message_tracker[0]["email_tracker_id"].to_s,@message_tracker[0]["company_id"].to_s])
			@allMessages.each do |message|
				logger.info(message.attributes)
				message.update_attributes({"answered" => "1"})
				message.save
			end
			@admin = "true"
			@a_str = "true"
			@subscribed = "true"
			@notKey = "false" 
			@company = Company.find(:all, :conditions => ["id = ?", @message_tracker[0]["company_id"]])
			@company = (@company[0])
			
			logger.info("email_tracker_id: " + @message_tracker[0]["email_tracker_id"].to_s + "\n") 

			@dReview = DraftReview.find(:all,:conditions => ["company_id = ? and email_tracker_id = ?", @company.id, @message_tracker[0]["email_tracker_id"]])
			logger.info("dReview " + @dReview.to_s)
			if @dReview.to_s == ""
				@investments = Investment.find(:all, :conditions => ["company_id = ?",@company["id"]])
				@products = Product.find(:all, :conditions => ["company_id = ?", @company["id"]])
				@personnels = Personnel.find(:all, :conditions => ["company_id =?", @company["id"]])
				@partnerships = Partnership.find(:all,:conditions => ["company_id = ?", @company["id"]])
				@company_category = CompanyCategory.find(:all,:conditions => ["company_id = ?", @company["id"]])
				@draft_review = DraftReview.new({"company_id" => @company["id"],"email_tracker_id" => @message_tracker[0]["email_tracker_id"]}) 
				@draft_review.save
			        @dID = @draft_review.id
				@dReview = Array.new
				@dReview.push(@draft_review)
				@draft_company = DraftCompany.new({"name"=>@company.name,"url"=>@company.url,"founded" => @company.founded, "employee_number" => @company.employee_number, "market_segment" => @company.market_segment, "description" => @company.description, "private_notes" => @company.private_notes, "draft_review_id" => @draft_review.id })
				@draft_company.save()
			
				@company = @draft_company 
				
				@investments.each do |investment|
					@draft_investment = DraftInvestment.new({"agency" => investment.agency, "funding_amount" => investment.funding_amount, "funding_type" => investment.funding_type, "company_id" => @company.id, "funding_date" => investment.funding_date })
					@draft_investment.save
				end 
				
				@products.each do |product|
					@draft_product = DraftProduct.new({"name" => product.name, "description" => product.description, "date_launched" => product.date_launched })
					@draft_product.save
				end 
				
				@personnels.each do |personnel|
					@draft_personnel = DraftPersonnel.new({"first_name" => personnel.first_name, "last_name" => personnel.last_name, "current_title" => personnel.current_title, "previous_title" => personnel.previous_title, "founder" => personnel.founder, "grad_edu" => personnel.grad_edu, "undergrad_edu" => personnel.undergrad_edu, "other_edu" => personnel.other_edu, "private_notes" => personnel.private_notes, "company_id" => @company.id }) 
					@draft_personnel.save
				end 
				
				@partnerships.each do |partnership|
					@draft_partnership = DraftPartnership.new({"name" => partnership.name, "date" => partnership.date, "description" => partnership.description, "company_id" => @company.id })
					@draft_partnership.save
				end 
				
			else
				@company = (DraftCompany.find(:all, :conditions => ["draft_review_id = ?", @dReview[0]["id"]]))[0]
				@dID = @dReview[0]["id"] 
			end 
		end
	end 
  
        
	if @notKey == "true"
       if current_user
			@subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
			@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
			@a_str = "false"
			@create = "false"
			if @admin.to_s != ""
				@create = params[:create]
				if @create == "true" 
					@a_str = "true"
				else 
					@a_str = params[:a_str]
				end 
				@subscribed = true 
			end 
		end
		if @create != "true"
		@company = Company.find(params[:id])
		end  
	end 

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end
  # GET /companies/new
  # GET /companies/new.xml
  def new    

    @company = Company.new
        

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])
    respond_to do |format|
      if @company.save
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(@company) }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])
    
      if @company.update_attributes(params[:company])
        unless params[:key].blank?
       
          redirect_to "/companies/show?key=#{params[:key]}"
        else
          redirect_to :action=>"show", :id=>params[:id]
        end
      else
       
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end

   
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml

 def destroy_item
   @company = Company.find(params[:id])
   CompanyCategory.delete_all(["company_id = ?", params[:id]])
   Product.delete_all(["company_id = ?", params[:id]])
   Personnel.delete_all(["company_id = ?", params[:id]])
   Investment.delete_all(["company_id = ?", params[:id]])
   Partnership.delete_all(["company_id = ?", params[:id]])
   @company.destroy
   respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end




  def get_company_list
    @companies = Company.find(:all).sort_by{|p| p.name}
    respond_to do |format|
	format.xml { render :count => @company_col_count, :xml => @companies }
    end 
  end

  def company_query
      @search = Ultrasphinx::Search.new(:query => @query)
      @search.run
      @search.results
      

  end


  def find_by_company_name
     @company = Company.find(:all, :conditions => ["name = ?", params[:name]])
    respond_to do |format|
      format.xml  { render :xml => @company }
    end



  end  


  def find_by_start_part
    enabled = false
    @company = Array.new
    @companyList = ""; 

		if(params[:part] == "other")
			   @company = Company.find(:all,:conditions => "name NOT LIKE 'A%' AND name NOT LIKE 'B%' AND name NOT LIKE 'C%' AND name NOT LIKE 'D%' AND name NOT LIKE 'E%' AND name NOT LIKE 'F%' AND name NOT LIKE 'B%' AND name NOT LIKE 'G%' AND name NOT LIKE 'H%' AND name NOT LIKE 'I%' AND name NOT LIKE 'J%' AND name NOT LIKE 'K%' AND name NOT LIKE 'L%' AND name NOT LIKE 'B%' AND name NOT LIKE 'M%' AND name NOT LIKE 'N%' AND name NOT LIKE 'O%' AND name NOT LIKE 'P%' AND name NOT LIKE 'Q%' AND name NOT LIKE 'R%' AND name NOT LIKE 'S%' AND name NOT LIKE 'T%' AND name NOT LIKE 'U%' AND name NOT LIKE 'V%' AND name NOT LIKE 'W%' AND name NOT LIKE 'X%' AND name NOT LIKE 'Y%' AND name NOT LIKE 'Z%'")

		elsif(params[:part] == "all") 
			   @company = Company.find(:all)
		else
			 @company = Company.find(:all,:conditions => ['name LIKE ?', params[:part] + '%'])
		end
		@company.each do  |company|
		   @companyList += company.id.to_s + ","
		 end 

	companyList = @companyList.split(",")
	count = 0
	conStr = "("
 
      for item in companyList 
        if not (count == 0)
           conStr += " or "
        end
		conStr +="((company_id = " + item + ")"; 
        count += 1
        catStr = params[:categoryList]
      		if catStr.length > 0
				scount = 0
				@company = ""
				catList = catStr.split(",")
        		conStr += " and ("
        		for item2 in catList
	  	 			if not (scount == 0)
    		       		conStr += " or "
	   				end 
	  				conStr += " (category_id = " + item2 + ")"
	   				scount += 1 
    			end
				conStr += ")"        	
      		end
       		conStr += ")"
      end
      conStr += ")"
	  @company_categories = CompanyCategory.find_by_sql("select * from company_categories where " + conStr)
	
	#@company_category = CompanyCategory.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	
	
    respond_to do |format|
      format.xml  
    end
  end


  def dateCompaniesCreated

	listOnly = true 
    if current_user  
		@subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
		@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
		@a_str = "false"
		if @admin.to_s != "" 
			@a_str = params[:a_str]
			@subscribed = true 
			sql = ActiveRecord::Base.connection();
			@companies = CompanyQueries.dateCreatedCompanies
			respond_to do |format|
				format.html
			end
		end


  end 
  end

def edit_basic_information
 @company = Company.find(:first, :conditions => ["id = ?", params[:id]])

render :layout=>false
end

def internal_show
 @company = Company.find(:first, :conditions => ["id = ?", params[:id]])
render :layout=>false
end

def update_internal_only
 @company = Company.find(:first, :conditions => ["id = ?", params[:company][:company_id]])
 @company[:private_notes]= params[:company][:private_notes]
 @company.save
  redirect_to :action=>"show", :id=>params[:company][:company_id]
end

 def desc_order_by_last_update
    get_email_tracker_info
    @companies = Company.find(:all).sort_by{|p| p.updated_at}.reverse
    render :partial => "asc_desc_link", :layout=>true
 end

 def asc_order_by_last_update
    get_email_tracker_info
    @companies = Company.find(:all).sort_by{|p| p.updated_at}
    render :partial =>"asc_desc_link", :layout=>true
 end

 def asc_order_by_name
    get_email_tracker_info
    @companies = Company.find(:all).sort_by{|p| p.name}
    render :partial =>"asc_desc_link",:layout=>true
 end

 def desc_order_by_name
    get_email_tracker_info
    @companies = Company.find(:all).sort_by{|p| p.name}.reverse
    render :partial =>"asc_desc_link",:layout=>true
 end

 def send_email_to_company
  company_id_string=params[:email_tracker][:company_ids]
  company_ids=company_id_string.to_s.split(",")
  company_ids.each do |company_id|
        @email_tracker = EmailTracker.new()
        @email_tracker[:message]=params[:email_tracker][:message]
	@email_tracker[:subject]=params[:email_tracker][:subject]
        @email_tracker[:return_email]=params[:email_tracker][:return_email]
	if @email_tracker.save
	   emailTSave = true
	end
debugger
        uuid = UUIDTools::UUID.timestamp_create
        @people = Personnel.find(:all, :conditions => ["company_id = ?",company_id])
        @companies = Company.find(:first, :conditions => ["id = ?",company_id])
		@people.each do |person|
			messageSentSuccess = false 
			unless person["email"].blank?
				message = params[:email_tracker][:message]
				message = message.gsub("[[first_name]]",person["first_name"])
				message = message.gsub("[[last_name]]",person["last_name"])
				message = message.gsub("[[company_name]]",@companies.name)
				message = message.gsub("[[return_email]]",@email_tracker["return_email"])
				urlKey = uuid.to_s
debugger
				urlLink = "http://www.health2advisors.com/companies/show?key="+urlKey
				message = message.gsub("[[link_company_profile]]",urlLink)
				CustomMessage.deliver_send_message_to_company(person.email,params[:email_tracker][:return_email],params[:email_tracker][:subject],message)
				@mTracker = MessageTracker.new({"email_tracker_id" => @email_tracker["id"],"company_id" => company_id,"answered" => false,"url_key" => urlKey})
				@mTracker.save()
                        end
                end

         end
      redirect_to :action=>"asc_order_by_last_update"
 end

def show_for_send_mail
   get_email_tracker_info
   render :layout=>false
end

private
  def get_email_tracker_info
   @email_tracker = EmailTracker.new
   @all_template=EmailTemplate.all
  end

end


class CompanyQueries < ActiveRecord::Base
  def self.pullAllCompanies
    # Notice how you can, and should, still sanitize params here. 
    self.connection.execute(sanitize_sql(["SELECT id, name FROM companies WHERE enabled=1 ORDER BY `companies`.`name` ASC"]))
  end
  def self.dateCreatedCompanies
    # Notice how you can, and should, still sanitize params here. 
    self.connection.execute(sanitize_sql(["SELECT id, name, created_at FROM companies ORDER BY `companies`.`created_at` DESC"]))
  end
  
end

####SELECT *

#FROM `companies`
#ORDER BY `companies`.`name` ASC
####LIMIT 0 , 30
