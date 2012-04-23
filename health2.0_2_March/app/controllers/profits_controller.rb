class ProfitsController < ApplicationController
  # GET /profits
  # GET /profits.xml
  def index
    @profits = Profit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profits }
    end
  end

  # GET /profits/1
  # GET /profits/1.xml
  def show
    @profit = Profit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profit }
    end
  end

  # GET /profits/new
  # GET /profits/new.xml
  def new
    @profit = Profit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profit }
    end
  end

  # GET /profits/1/edit
  def edit
    @profit = Profit.find(params[:id])
  end

  # POST /profits
  # POST /profits.xml
  def create
    @profit = Profit.new(params[:profit])

    respond_to do |format|
      if @profit.save
        flash[:notice] = 'Profit was successfully created.'
        format.html { redirect_to(@profit) }
        format.xml  { render :xml => @profit, :status => :created, :location => @profit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profits/1
  # PUT /profits/1.xml
  def update
    @profit = Profit.find(params[:id])

    respond_to do |format|
      if @profit.update_attributes(params[:profit])
        flash[:notice] = 'Profit was successfully updated.'
        format.html { redirect_to(@profit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profits/1
  # DELETE /profits/1.xml
  def destroy
    @profit = Profit.find(params[:id])
    @profit.destroy

    respond_to do |format|
      format.html { redirect_to(profits_url) }
      format.xml  { head :ok }
    end
  end

  def find_by_company
 	@profit = Profit.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @profit }
        end
  end 




end
