class DraftProductsController < ApplicationController
  # GET /draft_products
  # GET /draft_products.xml
  def index
    @draft_products = DraftProduct.all

    respond_to do |format|

      format.xml  { render :xml => @draft_products }
    end
  end

  # GET /draft_products/1
  # GET /draft_products/1.xml
  def show
    @draft_product = DraftProduct.find(params[:id])

    respond_to do |format|
   
      format.xml  { render :xml => @draft_product }
    end
  end

  # GET /draft_products/new
  # GET /draft_products/new.xml
  def new
    @draft_product = DraftProduct.new

    respond_to do |format|

      format.xml  { render :xml => @draft_product }
    end
  end

  # GET /draft_products/1/edit
  def edit
    @draft_product = DraftProduct.find(params[:id])
  end

  # POST /draft_products
  # POST /draft_products.xml
  def create
    @draft_product = DraftProduct.new(params[:product])

    respond_to do |format|
      if @draft_product.save
        flash[:notice] = 'DraftProduct was successfully created.'

        format.xml  { render :xml => @draft_product, :status => :created, :location => @draft_product }
      else
 
        format.xml  { render :xml => @draft_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /draft_products/1
  # PUT /draft_products/1.xml
  def update
    @draft_product = DraftProduct.find(params[:id])

    respond_to do |format|
      if @draft_product.update_attributes(params[:product])
        flash[:notice] = 'DraftProduct was successfully updated.'
        format.html { redirect_to(@draft_product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @draft_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /draft_products/1
  # DELETE /draft_products/1.xml
  def destroy
    @draft_product = DraftProduct.find(params[:id])
    @draft_product.destroy

    respond_to do |format|
      format.html { redirect_to(draft_products_url) }
      format.xml  { head :ok }
    end
  end
  def find_by_company
 	@product = DraftProduct.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @product }
        end
  end 


  def destroy_item
   @product = DraftProduct.find(params[:id])
   @product.destroy

    respond_to do |format|
      format.xml
    end
  end

end
