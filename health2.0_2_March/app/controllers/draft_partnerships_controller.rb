class DraftPartnershipsController < ApplicationController
  # GET /draft_partnerships
  # GET /draft_partnerships.xml
  def index
    @draft_partnerships = DraftPartnership.all

    respond_to do |format|
 
      format.xml  { render :xml => @draft_partnerships }
    end
  end

  # GET /draft_partnerships/1
  # GET /draft_partnerships/1.xml
  def show
    @draft_partnership = DraftPartnership.find(params[:id])

    respond_to do |format|
  
      format.xml  { render :xml => @draft_partnership }
    end
  end

  # GET /draft_partnerships/new
  # GET /draft_partnerships/new.xml
  def new
    @draft_partnership = DraftPartnership.new

    respond_to do |format|
     
      format.xml  { render :xml => @draft_partnership }
    end
  end


  def find_by_company
 	@partnership = DraftPartnership.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @partnership }
        end
  end 



  # GET /draft_partnerships/1/edit
  def edit
    @draft_partnership = DraftPartnership.find(params[:id])
  end

  # POST /draft_partnerships
  # POST /draft_partnerships.xml
  def create
    @draft_partnership = DraftPartnership.new(params[:partnership])

    respond_to do |format|
      if @draft_partnership.save

        format.xml  { render :xml => @draft_partnership, :status => :created, :location => @draft_partnership }
      else
    
        format.xml  { render :xml => @draft_partnership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /draft_partnerships/1
  # PUT /draft_partnerships/1.xml
  def update
    @draft_partnership = DraftPartnership.find(params[:id])

    respond_to do |format|
      if @draft_partnership.update_attributes(params[:partnership])

        format.xml  
      else
     
        format.xml  { render :xml => @draft_partnership.errors, :status => :unprocessable_entity }
      end
    end
  end

 def destroy_item
   @partnership = DraftPartnership.find(params[:id])
   @partnership.destroy

    respond_to do |format|
    
      format.xml 
    end
  end



  # DELETE /draft_partnerships/1
  # DELETE /draft_partnerships/1.xml
  def destroy
    @draft_partnership = DraftPartnership.find(params[:id])
    @draft_partnership.destroy

    respond_to do |format|
      format.html { redirect_to(draft_partnerships_url) }
      format.xml  { head :ok }
    end
  end
end
