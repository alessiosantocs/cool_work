class DraftPersonnelsController < ApplicationController
  # GET /draft_personnels
  # GET /draft_personnels.xml
  def index
    @draft_personnels = DraftPersonnel.all

    respond_to do |format|

      format.xml  { render :xml => @draft_personnels }
    end
  end

  # GET /draft_personnels/1
  # GET /draft_personnels/1.xml
  def show
    @draft_personnel = DraftPersonnel.find(params[:id])

    respond_to do |format|
   
      format.xml  { render :xml => @draft_personnel }
    end
  end

  # GET /draft_personnels/new
  # GET /draft_personnels/new.xml
  def new
    @draft_personnel = DraftPersonnel.new

    respond_to do |format|
   
      format.xml  { render :xml => @draft_personnel }
    end
  end

  # GET /draft_personnels/1/edit
  def edit
    @draft_personnel = DraftPersonnel.find(params[:id])
  end

  # POST /draft_personnels
  # POST /draft_personnels.xml
  def create
    @draft_personnel = DraftPersonnel.new(params[:personnel])

    respond_to do |format|
      if @draft_personnel.save
        flash[:notice] = 'DraftPersonnel was successfully created.'
               format.xml  { render :xml => @draft_personnel, :status => :created, :location => @draft_personnel }
      else
       
        format.xml  { render :xml => @draft_personnel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /draft_personnels/1
  # PUT /draft_personnels/1.xml
  def update
    @draft_personnel = DraftPersonnel.find(params[:id])

    respond_to do |format|
      if @draft_personnel.update_attributes(params[:personnel])
        flash[:notice] = 'DraftPersonnel was successfully updated.'
   
        format.xml 
      else
   
        format.xml  { render :xml => @draft_personnel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /draft_personnels/1
  # DELETE /draft_personnels/1.xml
  def destroy
    @draft_personnel = DraftPersonnel.find(params[:id])
    @draft_personnel.destroy

    respond_to do |format|

      format.xml  { head :ok }
    end
  end

  def find_by_company
        @personnel = DraftPersonnel.find(:all, :conditions => ["company_id = ?", params[:company_id]])
        respond_to do |format|
                format.xml  { render :xml => @personnel }
        end
  end


  def find_by_name
        @personnel = DraftPersonnel.find(:all, :conditions => ["first_name = ? and last_name = ? and company_id = ?", params[:first_name],params[:last_name], params[:companyID]])
        respond_to do |format|
                format.xml  { render :xml => @personnel }
        end



  end


 def destroy_item
   @personnel = DraftPersonnel.find(params[:id])
   @personnel.destroy

    respond_to do |format|
   
      format.xml  
    end
  end

end
