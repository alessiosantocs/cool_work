class PartnershipsController < ApplicationController
  # GET /partnerships
  # GET /partnerships.xml
  def index
    @partnerships = Partnership.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partnerships }
    end
  end

  # GET /partnerships/1
  # GET /partnerships/1.xml
  def show
    @partnership = Partnership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partnership }
    end
  end

  # GET /partnerships/new
  # GET /partnerships/new.xml
  def new
    @partnership = Partnership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partnership }
    end
  end

  # GET /partnerships/1/edit
  def edit
    @partnership = Partnership.find(params[:id])
  end

  # POST /partnerships
  # POST /partnerships.xml
  def create

    @partnership = Partnership.new(params[:partnership])


      if @partnership.save
     
         redirect_to :action=>"show", :controller=>"companies", :id=>params[:partnership][:company_id]
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partnership.errors, :status => :unprocessable_entity }
      end
   
  end

  # PUT /partnerships/1
  # PUT /partnerships/1.xml
  def update
    @partnership = Partnership.find(params[:id])

      if @partnership.update_attributes(params[:partnership])
        redirect_to :action=>"show", :controller=>"companies", :id=>params[:partnership][:company_id]
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partnership.errors, :status => :unprocessable_entity }
      end
    
  end

  # DELETE /partnerships/1
  # DELETE /partnerships/1.xml
  def destroy
    @partnership = Partnership.find(params[:id])
    @partnership.destroy

    respond_to do |format|
      format.html { redirect_to(partnerships_url) }
      format.xml  { head :ok }
    end
  end

  def find_by_company
 	@partnership = Partnership.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @partnership }
        end
  end 


 def destroy_item
   @partnership = Partnership.find(params[:id])
   @partnership.destroy

    respond_to do |format|
    
      format.xml 
    end
  end


    def add_partnerships
        if params[:partnership_id]
        @partnership = Partnership.find(:first, :conditions => ["id = ?", params[:partnership_id]])
        else
        @partnership = Partnership.new
        end
        render :layout=>false
    end



end
