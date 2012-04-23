class KeywordStoresController < ApplicationController
  # GET /keyword_stores
  # GET /keyword_stores.xml
  def index
    @keyword_stores = KeywordStore.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @keyword_stores }
    end
  end

  # GET /keyword_stores/1
  # GET /keyword_stores/1.xml
  def show
    @keyword_store = KeywordStore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @keyword_store }
    end
  end

  # GET /keyword_stores/new
  # GET /keyword_stores/new.xml
  def new
    @keyword_store = KeywordStore.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @keyword_store }
    end
  end

  # GET /keyword_stores/1/edit
  def edit
    @keyword_store = KeywordStore.find(params[:id])
  end

  # POST /keyword_stores
  # POST /keyword_stores.xml
  def create
    @keyword_store = KeywordStore.new(params[:keyword_store])

    respond_to do |format|
      if @keyword_store.save
        flash[:notice] = 'KeywordStore was successfully created.'
        format.html { redirect_to(@keyword_store) }
        format.xml  { render :xml => @keyword_store, :status => :created, :location => @keyword_store }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @keyword_store.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /keyword_stores/1
  # PUT /keyword_stores/1.xml
  def updateByCompany
    @keyword_store = KeywordStore.find(:all, :conditions => ["company_id = ?", params[:keyword_store][:company_id]])
    logger.info(@keyword_store.to_s)
    logger.info("hello")
	if @keyword_store.to_s == ""
	    @keyword_store = KeywordStore.new({"company_id"=>params[:keyword_store][:company_id],"keywords" => params[:keyword_store][:keywords]})		
		@keyword_store.save
	else 
		logger.info(@keyword_store[0]["id"])
		@keyword_store = KeywordStore.find(@keyword_store[0]["id"])
		
		@keyword_store.update_attributes({"keywords" => params[:keyword_store][:keywords]})
             
	end 
  redirect_to :action=>"show",:controller=>"companies",:id=>params[:keyword_store][:company_id]
  end


  def find_by_company
 	@keywords = KeywordStore.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @keywords }
        end
  end 


  # DELETE /keyword_stores/1
  # DELETE /keyword_stores/1.xml
  def destroy
    @keyword_store = KeywordStore.find(params[:id])
    @keyword_store.destroy

    respond_to do |format|
      format.html { redirect_to(keyword_stores_url) }
      format.xml  { head :ok }
    end
  end
  
  def modify_keyword

  @keyword_store=KeywordStore.find(:first ,:conditions=>["company_id = ?", params[:id]])
  render :layout=>false
  end
end
