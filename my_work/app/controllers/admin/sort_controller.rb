class Admin::SortController < ApplicationController
  require_role "sort"
  
  def index
    #render :action => :terminal, :area => params[:area] if params[:area]
    #redirect
    @terminals = Terminal.list.collect {|a| [a.name]}
  end
  
  def terminal
    @terminal = Terminal.for(params[:area])
    @area = params[:area]
  end
  
  def scanned
    #determine item type and reroute to appropriate view
    barcode = params[:barcode]
    type = Terminal.identify(barcode)
    context = params[:context] if params[:context]
    if Terminal.identify(context) == :bin
      terminal = Terminal.for(params[:area])
      terminal.open_bin(context)
      terminal.scan_into_bin(barcode) if type == :order_item
      redirect_to "/admin/terminal/#{params[:area]}/scanned_bin/#{context}" and return if type == :order_item
      redirect_to "/admin/terminal/#{params[:area]}/terminal" and return if type == :bin and barcode == terminal.active_bin.tracking_number
    end
    if Terminal.identify(context) == :stand
      terminal = Terminal.for(params[:area])
      terminal.open_rack(context)
      terminal.scan_onto_rack(barcode) if type == :order_item
      redirect_to "/admin/terminal/#{params[:area]}/scanned_rack/#{context}" and return if type == :order_item
      redirect_to "/admin/terminal/#{params[:area]}/terminal" and return if type == :stand and barcode == terminal.active_rack.tracking_number
    end
    if Terminal.identify(context) == :order_item
      terminal = Terminal.for(params[:area])
      terminal.scan_item(barcode) if type == :order_item
    end
    if Terminal.identify(context) == :order_part
      
    end
    redirect_to "/admin/terminal/#{params[:area]}/scanned_item/#{barcode}" if type == :order_item
    redirect_to "/admin/terminal/#{params[:area]}/scanned_bin/#{barcode}"  if type == :bin
    redirect_to "/admin/terminal/#{params[:area]}/scanned_rack/#{barcode}" if type == :stand
    redirect_to "/admin/terminal/#{params[:area]}/scanned_part/#{barcode}" if type == :order_part
  end
  
  def scanned_item
    @area = params[:area]
    @terminal = Terminal.for(@area)
    @item = OrderItem.find_by_tracking_number(params[:id])
    @context = @item.tracking_number
    #flash[:item] = @item
    #flash[:terminal] = @terminal
  end
  
  def scanned_rack
    @area = params[:area]
    @terminal = Terminal.for(@area)
    @rack = @terminal.open_rack(params[:id])
    @terminal.accept_rack(@rack.tracking_number)
    @context = @rack.tracking_number
    #flash[:rack] = @rack
    #flash[:terminal] = @terminal
  end
  
  def scanned_bin
    @area = params[:area]
    @terminal = Terminal.for(@area)
    @bin = @terminal.open_bin(params[:id])
    @terminal.accept_bin(@bin.tracking_number)
    @context = @bin.tracking_number
    flash[:bin] = @bin.tracking_number
    flash[:area] = @area.id
  end
  
  def scanned_part
    
  end
end
