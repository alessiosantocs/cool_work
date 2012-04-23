class DraftReviewsController < ApplicationController
  # GET /draft_reviews
  # GET /draft_reviews.xml
  def index
    @draft_reviews = DraftReview.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @draft_reviews }
    end
  end

  def processData
	companyID = params[:companyID]
	draftID = params[:draftID]
	section = params[:section]
	
	if (section == "company")
		company = Company.find(companyID)
		dcompany = DraftCompany.find(draftID)
		company.update_attributes({ "name" => dcompany.name, "url"=> dcompany.url, "founded" => dcompany.founded, "employee_number" => dcompany.employee_number, "market_segment" => dcompany.market_segment, "description" => dcompany.description})
		company.save
	end
	
	if (section == "category")
		cc1 = CompanyCategory.find(:all, :conditions => ["company_id = ?", companyID])
		cc1.each do |cc| 
			cc.delete 
		end
		dc = DraftCompanyCategory.find(:all, :conditions => ["company_id = ?", draftID])
		dc.each do |d|
			cc1 = CompanyCategory.new({ "company_id" => companyID, "category_id" =>  d.category_id })
			cc1.save
		end 
	end 
	
	if (section == "product")
		cc1 = Product.find(:all, :conditions => ["company_id = ?", companyID])
		cc1.each do |cc| 
			cc.delete 
		end  

		dc = DraftProduct.find(:all, :conditions => ["company_id = ?", draftID])
		dc.each do |d|
			cc1 = Product.new({ "company_id" => companyID, "name" =>  d.name, "date_launched" => d.date_launched, "description" => d.description })
			cc1.save
		end  

	end 
	
	if (section == "partnership")
		cc1 = Partnership.find(:all, :conditions => ["company_id = ?", companyID])
		cc1.each do |cc| 
			cc.delete 
		end 
		
		dc = DraftPartnership.find(:all, :conditions => ["company_id = ?", draftID])
		dc.each do |d|
			cc1 = Partnership.new({ "company_id" => companyID, "name" =>  d.name, "date" => d.date, "description" => d.description })
			cc1.save
		end  
		 
	end 
	
	if (section == "investment")
		cc1 = Investment.find(:all, :conditions => ["company_id = ?", companyID])
		cc1.each do |cc| 
			cc.delete 
		end
		
		dc = DraftInvestment.find(:all, :conditions => ["company_id = ?", draftID])
		dc.each do |d|
			cc1 = Investment.new({ "company_id" => companyID, "agency" =>  d.agency, "funding_amount" => d.funding_amount, "funding_date" => d.funding_date, "funding_type" => d.funding_type })
			cc1.save
		end   
	end 
	
	if (section == "personnel")
		cc1 = Personnel.find(:all, :conditions => ["company_id = ?", companyID])
		cc1.each do |cc| 
			cc.delete 
		end  
		
		dc = DraftPersonnel.find(:all, :conditions => ["company_id = ?", draftID])
		dc.each do |d|
			cc1 = Personnel.new({ "company_id" => companyID, "first_name" =>  d.first_name, "last_name" => d.last_name, "current_title" => d.current_title, "previous_title" => d.previous_title, "founder" => d.founder, "grad_edu" => d.grad_edu, "undergrad_edu" => d.undergrad_edu, "other_edu" => d.other_edu, "email" => d.email })
			cc1.save
		end  
		
	end 
	
	respond_to do |format|
		format.xml
	end 
  
  end


  # GET /draft_reviews/1
  # GET /draft_reviews/1.xml
#  def show
 #   @draft_review = DraftReview.find(params[:id])

  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @draft_review }
   ### end
 # end

  # GET /draft_reviews/new
  # GET /draft_reviews/new.xml
  def new
    @draft_review = DraftReview.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @draft_review }
    end
  end

  # GET /draft_reviews/1/edit
  def edit
    @draft_review = DraftReview.find(params[:id])
  end

  # POST /draft_reviews
  # POST /draft_reviews.xml
  def create
    @draft_review = DraftReview.new(params[:draft_review])

    respond_to do |format|
      if @draft_review.save
        flash[:notice] = 'DraftReview was successfully created.'
        format.html { redirect_to(@draft_review) }
        format.xml  { render :xml => @draft_review, :status => :created, :location => @draft_review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @draft_review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /draft_reviews/1
  # PUT /draft_reviews/1.xml
  def update
    @draft_review = DraftReview.find(params[:id])

    respond_to do |format|
      if @draft_review.update_attributes(params[:draft_review])
        flash[:notice] = 'DraftReview was successfully updated.'
        format.html { redirect_to(@draft_review) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @draft_review.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def email_campaign_list 
	@email_tracker = EmailTracker.all 
    respond_to do |format|
      format.html
    end  
  end 

  def draft_review_list 
	@draft_reviews = DraftReview.find(:all, :conditions=>["email_tracker_id = ?",params[:email_tracker_id]])
	respond_to do |format|
      format.html
    end  
  end 

  def post_accepted
     @dr = DraftReview.find(params[:id])
	 @dr.update_attributes({"accepted" => '1', "processed" => "0"})
	 @dr.save
	 
	 respond_to do |format|
      format.xml
    end  
  end 
  
  def post_processed
     @dr = DraftReview.find(params[:id])
	 @dr.update_attributes({"processed" => '1'})
	 @dr.save  
  
  	respond_to do |format|
      format.xml
    end  
  end 



  def show
   @dr = DraftReview.find(params[:id])
   
	@company = Company.find(@dr.company_id)
    company_id = @company.id
	#@dr = Draft_Review.find(parmas[:dr_id])
	@investments = Investment.find(:all,:conditions => ["company_id = ?",company_id])
	@products = Product.find(:all,:conditions => ["company_id = ?",company_id])
	@partnerships = Partnership.find(:all,:conditions => ["company_id = ?",company_id])
	@personnels = Personnel.find(:all,:conditions => ["company_id = ?",company_id])


	@investmentsString = "<ul>"
	@investments.each do |investment|
		@investmentsString += "<li>"
		@investmentsString += "Agency: " + investment.agency + "<br/>"
		@investmentsString += "Funding Amount: " + investment.funding_amount.to_s + "<br/>"
		@investmentsString += "Funding Date: " + investment.funding_date.to_s + "<br/>"
		@investmentsString += "Funding Type: " + investment.funding_type + "<br/>"
		@investmentsString += "</li>"	  
	end 
	@investmentsString += "</ul>"	
	
	
	@productsString = "<ul>"
	@products.each do |product|
		@productsString += "<li>"
		@productsString += "Name: " + product.name + "<br/>"
		@productsString += "Date Launched: " + product.date_launched.to_s + "<br/>"
		@productsString += "Description: " + product.description + "<br/>"
		@productsString += "</li>"	  
	end 
	@productsString += "</ul>"	
	
	@partnershipsString = "<ul>"
	@partnerships.each do |partnership|
		@partnershipsString += "<li>"
		#@partnershipsString += "Name: " + partnership.name + "<br/>"
		@partnershipsString += "Date: " + partnership.date.to_s + "<br/>"
		@partnershipsString += "Description: " + partnership.description + "<br/>"
		@partnershipsString += "</li>"	  
	end 
	@partnershipsString += "</ul>"
	
	@personnelsString = "<ul>"
	@personnels.each do |personnel|
		@personnelsString += "<li>"
		@personnelsString += "First Name: " + personnel.first_name + "<br/>"
		@personnelsString += "Last Name: " + personnel.last_name + "<br/>"
		@personnelsString += "Email: " + personnel.email + "<br/>"
		@personnelsString += "Current title: " + personnel.current_title + "<br/>"
		@personnelsString += "Previous companies: " + personnel.previous_title + "<br/>"
		@personnelsString += "Founder: " + personnel.founder.to_s + "<br/>"
		@personnelsString += "Graduate education: " + personnel.grad_edu + "<br/>"
		@personnelsString += "Undergraduate education: " + personnel.undergrad_edu + "<br/>"
		@personnelsString += "Other education: " + personnel.other_edu + "<br/>"
		@personnelsString += "</li>"	  
	end 
	@personnelsString += "</ul>"

	
	@company_categories = CompanyCategory.find(:all,:conditions => ["company_id = ?",company_id])

	@ccString = ""
	
	@company_categories.each do |company_category|
		@ccString += Category.find(company_category.category_id).name + ", "
	end
	
	@draft_company = DraftCompany.find(:all,:conditions => ["draft_review_id = ?",@dr.id])[0]
	dc_id = @draft_company.id 
	@draft_investments = DraftInvestment.find(:all, :conditions => ["company_id = ?", dc_id])
	@draft_products = DraftProduct.find(:all, :conditions => ["company_id = ?", dc_id])
	@draft_partnerships = DraftPartnership.find(:all, :conditions => ["company_id = ?", dc_id])
	@draft_personnels = DraftPersonnel.find(:all, :conditions => ["company_id = ?", dc_id])
	@draft_company_categories = DraftCompanyCategory.find(:all, :conditions => ["company_id = ?", dc_id])

	@d_ccString = ""
	
	@draft_company_categories.each do |company_category|
		@d_ccString += Category.find(company_category.category_id).name + ", "
	end


	@d_investmentsString = "<ul>"
	@draft_investments.each do |investment|
		@d_investmentsString += "<li>"
		@d_investmentsString += "Agency: " + investment.agency + "<br/>"
		@d_investmentsString += "Funding Amount: " + investment.funding_amount.to_s + "<br/>"
		@d_investmentsString += "Funding Date: " + investment.funding_date.to_s + "<br/>"
		@d_investmentsString += "Funding Type: " + investment.funding_type + "<br/>"
		@d_investmentsString += "</li>"	  
	end 
	@d_investmentsString += "</ul>"	
	
	
	@d_productsString = "<ul>"
	@draft_products.each do |product|
		@d_productsString += "<li>"
		@d_productsString += "Name: " + product.name + "<br/>"
		@d_productsString += "Date Launched: " + product.date_launched.to_s + "<br/>"
		@d_productsString += "Description: " + product.description + "<br/>"
		@d_productsString += "</li>"	  
	end 
	@d_productsString += "</ul>"	
	
	@d_partnershipsString = "<ul>"
	@draft_partnerships.each do |partnership|
		@d_partnershipsString += "<li>"
		#@d_partnershipsString += "Name: " + partnership.name + "<br/>"
		@d_partnershipsString += "Date: " + partnership.date.to_s + "<br/>"
		@d_partnershipsString += "Description: " + partnership.description + "<br/>"
		@d_partnershipsString += "</li>"	  
	end 
	@d_partnershipsString += "</ul>"
	
	@d_personnelsString = "<ul>"
	@draft_personnels.each do |personnel|
		@d_personnelsString += "<li>"
		@d_personnelsString += "First Name: " + personnel.first_name + "<br/>"
		@d_personnelsString += "Last Name: " + personnel.last_name + "<br/>"
		@d_personnelsString += "Email: " + personnel.email.to_s + "<br/>"
		@d_personnelsString += "Current title: " + personnel.current_title + "<br/>"
		@d_personnelsString += "Previous companies: " + personnel.previous_title + "<br/>"
		@d_personnelsString += "Founder: " + personnel.founder.to_s + "<br/>"
		@d_personnelsString += "Graduate education: " + personnel.grad_edu + "<br/>"
		@d_personnelsString += "Undergraduate education: " + personnel.undergrad_edu + "<br/>"
		@d_personnelsString += "Other education: " + personnel.other_edu + "<br/>"
		@d_personnelsString += "</li>"	  
	end 
	@d_personnelsString += "</ul>"
	
	
	
	respond_to do |format|
      format.html
    end 
  end 

  # DELETE /draft_reviews/1
  # DELETE /draft_reviews/1.xml
  def destroy
    @draft_review = DraftReview.find(params[:id])
    @draft_review.destroy

    respond_to do |format|
      format.html { redirect_to(draft_reviews_url) }
      format.xml  { head :ok }
    end
  end
end
