class DraftCompanyCategoriesController < ApplicationController
  # GET /draft_company_categories
  # GET /draft_company_categories.xml
  def index
    @draft_company_categories = DraftCompanyCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @draft_company_categories }
    end
  end

  # GET /draft_company_categories/1
  # GET /draft_company_categories/1.xml
  def show
    @draft_company_category = DraftCompanyCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @draft_company_category }
    end
  end

  # GET /draft_company_categories/new
  # GET /draft_company_categories/new.xml
  def new
    @draft_company_category = DraftCompanyCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @draft_company_category }
    end
  end

  # GET /draft_company_categories/1/edit
  def edit
    @draft_company_category = DraftCompanyCategory.find(params[:id])
  end

  # POST /draft_company_categories
  # POST /draft_company_categories.xml
  def create
    @draft_company_category = DraftCompanyCategory.new(params[:company_category])

    respond_to do |format|
      if @draft_company_category.save
        format.xml 
      else
        format.xml 
      end
    end
  end

  # PUT /draft_company_categories/1
  # PUT /draft_company_categories/1.xml
  def update
    @draft_company_category = DraftCompanyCategory.find(params[:id])

    respond_to do |format|
      if @draft_company_category.update_attributes(params[:draft_company_category])

        format.xml  
      else
  
        format.xml  
      end
    end
  end

  # DELETE /draft_company_categories/1
  # DELETE /draft_company_categories/1.xml
  def destroy
    @draft_company_category = DraftCompanyCategory.find(params[:id])
    @draft_company_category.destroy

    respond_to do |format|
      format.html { redirect_to(draft_company_categories_url) }
      format.xml  { head :ok }
    end
  end
  
  
  
  
  def find_by_company
 	@company_category = DraftCompanyCategory.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @company_category }
        end
  end 


  def return_category_names
 	@company_category = DraftCompanyCategory.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	@catList = Array.new
 	@company_category.each do |cc|
		@catList.append(Category.find(cc.category_id).name)
 	end
	respond_to do |format|
    		format.xml 
        end
  end 


  def find_by_category
 	@company_category = DraftCompanyCategory.find(:all, :conditions => ["category_id = ?", params[:category_id]])
	respond_to do |format|
    		format.xml  { render :xml => @company_category }
        end
  end 

  def destroy_item
     @company_category = DraftCompanyCategory.find(params[:id])
    @company_category.destroy

    respond_to do |format|
      format.xml
    end


  end

  def find_by_companies
      companyList = params[:companyList].split(",")
      conStr = "("
      count = 0	
      for item in companyList 
        if not (count == 0)
           conStr += " or "
        end
		conStr +="((company_id = " + item + ")"; 
        count += 1
        catStr = params[:categoryList]
      		if catStr.length > 0
				scount = 0
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

      @company_category = DraftCompanyCategory.find_by_sql("select * from company_categories where " + conStr)
      respond_to do |format|
          format.xml  { render :xml => @company_category }
      end
   end 

  
  
end
