class Admin::PricesController < ApplicationController

  def index
    @prices = Price.find(:all, :joins=>[:item_type], :conditions => ["service_id = ? AND is_active = TRUE", params[:service_id]], :order => 'item_types.name asc')
  end

  def update
    unless params[:price].blank?
      price_field = params[:price][:price]
      premium_field = params[:price][:premium]
      additional_standard_field = params[:price][:each_additional_standard]
      additional_premium_field = params[:price][:each_additional_premium]
      plant_price_field = params[:price][:plant_price]
      plant_premium_price_field = params[:price][:plant_premium_price]
      price_id = params[:price][:id]
      index = 0
      price_id.each do |p_id|
        price = Price.find(p_id)
        price_field[index] = 0.00 if price_field[index] == ''
        price.update_attribute(:price, price_field[index])
        premium_field[index] = 0.00 if premium_field[index] == ''
        price.update_attribute(:premium, premium_field[index])
        additional_premium_field[index] = 0.00 if additional_premium_field[index] == ''
        price.update_attribute(:each_additional_premium, additional_premium_field[index])
        additional_standard_field[index] = 0.00 if additional_standard_field[index] == ''
        price.update_attribute(:each_additional_standard, additional_standard_field[index])
        plant_price_field[index] = 0.00 if plant_price_field[index] == ''
        price.update_attribute(:plant_price, plant_price_field[index])
        plant_premium_price_field[index] = 0.00 if plant_premium_price_field[index] == ''
        price.update_attribute(:plant_premium_price, plant_premium_price_field[index])
        index = index + 1
      end
    end
    flash[:notice] = "Items are updated successfully"
    redirect_to "/admin/services/#{params[:service_id]}/prices"
  end

  def edit

  end

  def new
    @price = Price.new
    render :layout => false
  end

  def create
    item_type = ItemType.new(params[:item_type])
    params[:price][:water] = params[:price][:water].to_f
    params[:price][:carbon] = params[:price][:carbon].to_f
    params[:price][:point_value] = params[:price][:point_value].to_f
    params[:price][:premium] = params[:price][:premium].to_f
    params[:price][:price] = params[:price][:price].to_f
    params[:price][:plant_price] = params[:price][:plant_price].to_f
    params[:price][:plant_premium_price] = params[:price][:plant_premium_price].to_f
    price = Price.new(params[:price])
    price.service_id = params[:service_id]
    price.item_type = item_type
    if price.save!
      flash[:notice] = "Item is created successfully"
    else
      flash[:error] = "There is some error occured"
    end
    redirect_to admin_service_prices_path(params[:service_id])
  end
  
  def show
  end

  def destroy
    item_price = Price.find(params[:id])
    item_price.is_active = false
    item_price.save!
    flash[:notice] = "Item is deleted successfully"
    redirect_to admin_service_prices_path(params[:service_id])
  end
end
