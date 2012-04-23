class DraftInvestmentsController < ApplicationController
  # GET /draft_investments
  # GET /draft_investments.xml
  def index
    @draft_investments = DraftInvestment.all

    respond_to do |format|

      format.xml  { render :xml => @draft_investments }
    end
  end

  # GET /draft_investments/1
  # GET /draft_investments/1.xml
  def show
    @draft_investment = DraftInvestment.find(params[:id])

    respond_to do |format|

      format.xml  { render :xml => @draft_investment }
    end
  end

  # GET /draft_investments/new
  # GET /draft_investments/new.xml
  def new
    @draft_investment = DraftInvestment.new

    respond_to do |format|

      format.xml  { render :xml => @draft_investment }
    end
  end

  # GET /draft_investments/1/edit
  def edit
    @draft_investment = DraftInvestment.find(params[:id])
  end

  # POST /draft_investments
  # POST /draft_investments.xml
  def create
 @data = params[:investment]
    @investment= DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?",@data[:company_id], @data[:funding_type]])
    if @investment.to_s != ""
       @invest = DraftInvestment.find(@investment[0][:id])
	   @invest.update_attributes({"agency"  => @investment[0]["agency"] + ", " + @data[:agency],"funding_amount" => (@data["funding_amount"].to_i + @investment[0]["funding_amount"]).to_s})
       respond_to do |format|
          format.xml  
		end 
	   
    else

      @investment = DraftInvestment.new(params[:investment])
          respond_to do |format|
      if @investment.save
        flash[:notice] = 'Investment was successfully created.'

        format.xml  { render :xml => @investment, :status => :created, :location => @investment }
      else

        format.xml  { render :xml => @investment.errors, :status => :unprocessable_entity }
      end
    end
      
    end

  end

  # PUT /draft_investments/1
  # PUT /draft_investments/1.xml
  def update
    @draft_investment = DraftInvestment.find(params[:id])

    respond_to do |format|
      if @draft_investment.update_attributes(params[:investment])

        format.xml 
      else

        format.xml  { render :xml => @draft_investment.errors, :status => :unprocessable_entity }
      end
    end
  end


  def find_by_company
 
 	@angel = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "angel"])
	@seed = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seed"])
 	@seriesa = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesa"])
 	@seriesb = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesb"])
 	@seriesc = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesc"])
 	@seriesd = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesd"])
 	@seriese = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriese"])
 	@seriesf = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesf"])
 	@seriesg = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "seriesg"])
  	@purchased = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "purchased"])
  	@ipo = DraftInvestment.find(:all, :conditions => ["company_id = ? AND funding_type = ?", params[:company_id], "ipo"])


 	
	respond_to do |format|
    		format.xml 
        end
    end 

 def destroy_item
   @investment = DraftInvestment.find(params[:id])
   @investment.destroy

    respond_to do |format|

      format.xml  
    end
  end





  # DELETE /draft_investments/1
  # DELETE /draft_investments/1.xml
  def destroy
    @draft_investment = DraftInvestment.find(params[:id])
    @draft_investment.destroy

    respond_to do |format|

      format.xml  { head :ok }
    end
  end
end
