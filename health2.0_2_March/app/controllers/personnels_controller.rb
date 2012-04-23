class PersonnelsController < ApplicationController
  # GET /personnels
  # GET /personnels.xml
  def index
    @personnels = Personnel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personnels }
    end
  end

  # GET /personnels/1
  # GET /personnels/1.xml
  def show
    @personnel = Personnel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personnel }
    end
  end

  # GET /personnels/new
  # GET /personnels/new.xml
  def new
    
    @personnel = Personnel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personnel }
    end
  end

  # GET /personnels/1/edit
  def edit
    @personnel = Personnel.find(params[:id])
  end

  # POST /personnels
  # POST /personnels.xml
  def create

    @personnel = Personnel.new(params[:personnel])
      if @personnel.save
        unless params[:key].blank?
          redirect_to "/companies/show?key=#{params[:key]}"
        else
          redirect_to :action=>"show", :controller=>"companies", :id=>params[:personnel][:company_id]
        end
     
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personnel.errors, :status => :unprocessable_entity }
      end
   
  end

  # PUT /personnels/1
  # PUT /personnels/1.xml
  def update
    @personnel = Personnel.find(params[:id])
  
      if @personnel.update_attributes(params[:personnel])
        redirect_to :action=>"show", :controller=>"companies", :id=>params[:personnel][:company_id]
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personnel.errors, :status => :unprocessable_entity }
      end
  end

  # DELETE /personnels/1
  # DELETE /personnels/1.xml
  def destroy
    @personnel = Personnel.find(params[:id])
    @personnel.destroy

    respond_to do |format|
      format.html { redirect_to(personnels_url) }
      format.xml  { head :ok }
    end
  end

 

  def find_by_company
        @personnel = Personnel.find(:all, :conditions => ["company_id = ?", params[:company_id]])
        respond_to do |format|
                format.xml  { render :xml => @personnel }
        end
  end


  def find_by_name
        @personnel = Personnel.find(:all, :conditions => ["first_name = ? and last_name = ? and company_id = ?", params[:first_name],params[:last_name], params[:companyID]])
        respond_to do |format|
                format.xml  { render :xml => @personnel }
        end



  end


 def destroy_item
   @personnel = Personnel.find(params[:id])
   @personnel.destroy

    respond_to do |format|
   
      format.xml  
    end
  end

def add_people
    if params[:person_id]
        @personnel = Personnel.find(:first ,:conditions=>["id = ? ",params[:person_id]])
    else 
    @personnel = Personnel.new
    end
render :layout=>false
end
   

end
