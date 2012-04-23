class InvestmentsController < ApplicationController
  #before_filter :find_company

  # GET /investments
  # GET /investments.xml
  def index
    @investments = Investment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @investments }
    end
  end

  # GET /investments/1
  # GET /investments/1.xml
  def show
    @investment = Investment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @investment }
    end
  end

  # GET /investments/new
  # GET /investments/new.xml
  def new

    @investment = Investment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @investment }
    end
  end

  # GET /investments/1/edit
  def edit
    @investment = Investment.find(params[:id])
  end

  # POST /investments
  # POST /investments.xml
  def create

    @data = params[:investment]
    @investment= Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?",@data[:company_id], params[:itype]])
    if @investment.to_s != ""
       @invest = Investment.find(@investment[0][:id])
	   @invest.update_attributes({"agency"  => @investment[0]["agency"] + ", " + @data[:agency],"funding_amount" => (@data["funding_amount"].to_i + @investment[0]["funding_amount"]).to_s})
          redirect_to :action=>"show", :controller=>"companies", :id=> params[:investment][:company_id]
	   
    else

      @investment = Investment.new(params[:investment])
      @investment[:funding_type]=params[:itype]
      if @investment.save
           redirect_to :action=>"show", :controller=>"companies", :id=> params[:investment][:company_id]
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @investment.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /investments/1
  # PUT /investments/1.xml
  def update
    @investment = Investment.find(params[:id])
      if @investment.update_attributes(params[:investment])
      redirect_to :action=>"show", :controller=>"companies", :id=> params[:investment][:company_id]
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @investment.errors, :status => :unprocessable_entity }
      end
 
  end

  # DELETE /investments/1
  # DELETE /investments/1.xml
  def destroy
    @investment = Investment.find(params[:id])
    @investment.destroy

    respond_to do |format|
      format.html { redirect_to(investments_url) }
      format.xml  { head :ok }
    end
  end

  def find_by_company
 
 	@angel = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "angel"])
	@seed = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seed"])
 	@seriesa = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesa"])
 	@seriesb = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesb"])
 	@seriesc = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesc"])
 	@seriesd = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesd"])
 	@seriese = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriese"])
 	@seriesf = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesf"])
 	@seriesg = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesg"])
  	@purchased = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "purchased"])
  	@ipo = Investment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "ipo"])


 	
	respond_to do |format|
    		format.xml 
        end
  end 

 def destroy_item
   @investment = Investment.find(params[:id])
   @investment.destroy

    respond_to do |format|
      format.html { redirect_to(investments_url) }
      format.xml  { head :ok }
    end
  end

def add_investments
    if params[:investment_id]
     @investment = Investment.find(:first,:conditions=>["id = ? ",params[:investment_id]])
    else 
     @investment = Investment.new
    end
render :layout=>false
end


  private

  def find_company
      @company = Company.find(params[:company_id])
  end



	

end


