class CompanyCategoriesController < ApplicationController
  # GET /company_categories
  # GET /company_categories.xml
  def index
    @company_categories = CompanyCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @company_categories }
    end
  end

  # GET /company_categories/1
  # GET /company_categories/1.xml
  def show
    @company_category = CompanyCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company_category }
    end
  end

  # GET /company_categories/new
  # GET /company_categories/new.xml
  def new
    @company_category = CompanyCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company_category }
    end
  end

  # GET /company_categories/1/edit
  def edit
    @company_category = CompanyCategory.find(params[:id])
  end

  # POST /company_categories
  # POST /company_categories.xml
  def create
    @company_category = CompanyCategory.new(params[:company_category])

    respond_to do |format|
      if @company_category.save
        flash[:notice] = 'CompanyCategory was successfully created.'
        format.html { redirect_to(@company_category) }
        format.xml  { render :xml => @company_category, :status => :created, :location => @company_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /company_categories/1
  # PUT /company_categories/1.xml
  def update
    @company_category = CompanyCategory.find(params[:id])

    respond_to do |format|
      if @company_category.update_attributes(params[:company_category])
        flash[:notice] = 'CompanyCategory was successfully updated.'
        format.html { redirect_to(@company_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /company_categories/1
  # DELETE /company_categories/1.xml
  def destroy
    @company_category = CompanyCategory.find(params[:id])
    @company_category.destroy

    respond_to do |format|
      format.html { redirect_to(company_categories_url) }
      format.xml  { head :ok }
    end
  end

  def find_by_company
 	@company_category = CompanyCategory.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @company_category }
        end
  end 


  def return_category_names
 	@company_category = CompanyCategory.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	@catList = Array.new
 	@company_category.each do |cc|
		@catList.append(Category.find(cc.category_id).name)
 	end
	respond_to do |format|
    		format.xml 
        end
  end 


  def find_by_category
 	@company_category = CompanyCategory.find(:all, :conditions => ["category_id = ?", params[:category_id]])
	respond_to do |format|
    		format.xml  { render :xml => @company_category }
        end
  end 

  def destroy_item
     @company_category = CompanyCategory.find(params[:id])
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

      @company_category = CompanyCategory.find_by_sql("select * from company_categories where " + conStr)
      respond_to do |format|
          format.xml  { render :xml => @company_category }
      end
   end 
  
  def show_segment
   @category=Category.all
   render :layout=>false
  end
 
 def updateCategoryForCompany
    company_id=params[:category][:company_id]
    category_ids=params[:category][:id]
    obj=CompanyCategory.find(:all,:conditions=>["company_id = ? AND category_id not in (?) ",company_id,category_ids.blank? ? '' : company_id])
    unless obj.blank?
        obj.each do |f|
            f.destroy
        end 
    end
    unless category_ids.blank?
        category_ids.each do |category_id|
            existing_company_category=CompanyCategory.find(:all,:conditions=>["company_id = ? AND category_id = ? ",company_id,category_id])
            if existing_company_category.blank?
                CompanyCategory.create(:category_id =>category_id,:company_id=>company_id)
            end
        end
    end
    redirect_to :action=>"show", :controller=>"companies",:id=>company_id

 end 

end
