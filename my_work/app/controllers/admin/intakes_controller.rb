class Admin::IntakesController < ApplicationController
  require_role "intake"
  
  def index
    params[:sort] ? sort = params[:sort] : sort = 'updated_at'
    if params[:orderby] && !params[:orderby].empty?
      sort = sort + " #{params[:orderby]}"
      params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
    else
      sort = sort + " desc"
      @orderby = 'asc'
    end
    if !params[:search].blank?
      @orders = Order.intake_search(sort, params[:search])
      @orders = @orders.paginate :page => params[:page], :per_page => 25 unless @orders.blank?
    else
      @orders = Order.intake_orders(sort).paginate :page => params[:page], :per_page => 25
    end    
  end
  
  def sort
    @order = Order.find(params[:id])
    @services = Service.find(:all)
  end
  
  def quick_sort
    @order = Order.find(params[:id])
    @services = Service.find(:all)
  end
  
  def quick_sort_and_verify
    @order = Order.find(params[:id])
    
    for item_type in ItemType.find(:all)
      type_items = @order.items_from_type(item_type,item_type.services.first.id)
      qty = params['quantity_item_type_'+item_type.id.to_s].to_i - type_items.size
      weight = params['weight_item_type_'+item_type.id.to_s].to_f
      
      if weight != nil && weight > 0.0
        item = type_items.first
        if type_items.first != nil
          item.weight = weight
          item.save!
        else
          customer_item = CustomerItem.new(:customer => @order.customer, :item_type => item_type)
          @order.order_items.build(:customer_item => customer_item, :service_id => item_type.services.first.id, :weight => weight)
        end
      elsif qty > 0
        for i in 1..qty
          customer_item = CustomerItem.new(:customer => @order.customer, :item_type => item_type)
          @instruction = Instructions.create()
          customer_item.instructions_id = @instruction.id 
          @order.order_items.build(:customer_item => customer_item, :service_id => item_type.services.first.id)
        end
      elsif qty < 0
        for i in qty..-1
          type_items.last.destroy
        end
      end
    end
    
    @order.save!
    @order.verify_all!
    redirect_to sort_admin_intake_path(@order)
  end
  
  def ticket
    @order = Order.find(params[:id])
    @services = Service.find(:all)
    render :layout => 'zip'
  end
  
  def tickets
    @order = Order.find(params[:id])
    @services = Service.find(:all)
    render :layout => 'zip'
  end
  
  def finalize_order
    @order = Order.find(params[:id])
    @order.update_attributes(params[:order])
    
    if @order.finalize!
      @services = Service.find(:all)
      Notifier.deliver_itemization(@order, @services)
      flash[:notice] = 'Order was successfully processed.'
      redirect_to '/admin/intakes'
    else
      flash[:error] = 'There was a problem authorizing payment for this order. Intake process cannot be finalized.'
      Notifier.deliver_authorization_failure(@order)
      redirect_to sort_admin_intake_path(@order)
    end
  end
end
