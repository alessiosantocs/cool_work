class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])
      if @product.save
       redirect_to :action=>"show", :controller=>"companies", :id=> params[:product][:company_id]
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])


      if @product.update_attributes(params[:product])
        redirect_to :action=>"show", :controller=>"companies", :id=> params[:product][:company_id]
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end

  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def find_by_company
 	@product = Product.find(:all, :conditions => ["company_id = ?", params[:company_id]])
	respond_to do |format|
    		format.xml  { render :xml => @product }
        end
  end 


  def destroy_item
   @product = Product.find(params[:id])
   @product.destroy

    respond_to do |format|
      format.xml
    end
  end

    def add_products
        if params[:product_id]
        @product = Product.find(:first, :conditions => ["id = ?",params[:product_id]])
        else
        @product =Product.new
        end
        render :layout=>false
    end

end
