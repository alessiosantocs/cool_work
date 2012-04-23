class Admin::ReportingController < ApplicationController
  require_role "reporting"
  before_filter :set_date, :only => [:monthwise_category_report, :monthwise_item_type_report, :monthwise_customer_report, :monthwise_promotion_report, :daywise_order_report,:monthwise_recurring_order_report]
  before_filter :set_date_range, :only => [:selected_monthwise_category_report, :selected_monthwise_item_type_report, :selected_monthwise_customer_report, :selected_monthwise_promotion_report, :month_rangewise_order_report]

  def index
    redirect_to :action => :monthwise_promotion_report, :controller => "reporting"
  end

  def get_report
    redirect_to :action => params[:report_type], :controller => "reporting"
  end

  def monthwise_category_report
    @result = get_monthly( "service" )
    total_result=@result["total"]
    @result.delete_if{|key,value| key == "total"}
    add_hash=Hash.new
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
    unless params[:sort].blank?
      if params[:orderby] =='asc'
        @result = sort_result(@result,params[:sort]) 
      else
        @result = sort_result_desc(@result,params[:sort]) 
      end
    else 
      if params[:orderby] =='asc'
         @result = sort_result_by_name(@result)
      else 
        @result = sort_result_by_name_desc(@result)
      end
    end
    add_hash={"total"=>total_result}
    @result << add_hash
  end

  def selected_monthwise_category_report
    @selected_month_result = {}
    from_month = @from_month.to_i
    from_year = @from_year.to_i
    to_date = Date.civil(@to_year.to_i, @to_month.to_i)
    while Date.civil(from_year, from_month) <= to_date
        @month = from_month
        @year = from_year
        @selected_month_result[Date.civil(from_year, from_month)] = get_monthly( "service" )
        from_month += 1
        if from_month > 12
          from_month = 1
          from_year += 1
        end
    end
    @selected_month_result = @selected_month_result.sort
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
  end

  def monthwise_item_type_report
    @result = get_monthly( "item_type" )
    total_result=@result["total"]
    @result.delete_if{|key,value| key == "total"}
    add_hash=Hash.new
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
    unless params[:sort].blank?
      if params[:orderby] =='asc'
        @result = sort_result(@result,params[:sort]) 
      else
        @result = sort_result_desc(@result,params[:sort]) 
      end
    else 
      if params[:orderby] =='asc'
         @result = sort_result_by_name(@result)
      else 
        @result = sort_result_by_name_desc(@result)
      end
    end
    add_hash={"total"=>total_result}
    @result << add_hash
  end

  def selected_monthwise_item_type_report
    @selected_month_result = {}
    from_month = @from_month.to_i
    from_year = @from_year.to_i
    to_date = Date.civil(@to_year.to_i, @to_month.to_i)
    while Date.civil(from_year, from_month) <= to_date
        @month = from_month
        @year = from_year
        @selected_month_result[Date.civil(from_year, from_month)] = get_monthly( "item_type" )
        from_month += 1
        if from_month > 12
          from_month = 1
          from_year += 1
        end
    end
    @selected_month_result = @selected_month_result.sort
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
  end

  def monthwise_customer_report
    @result = get_range_wise( "customer" )
    total_result=@result["total"]
    @result.delete_if{|key,value| key == "total"}
    add_hash=Hash.new
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
    unless params[:sort].blank?
      if params[:orderby] =='asc'
        @result = sort_result(@result,params[:sort]) 
      else
        @result = sort_result_desc(@result,params[:sort]) 
      end
    else 
      if params[:orderby] =='asc'
         @result = sort_result_by_name(@result)
      else 
        @result = sort_result_by_name_desc(@result)
      end
    end
    add_hash={"total"=>total_result}
    @result << add_hash
  end

  def selected_monthwise_customer_report
    @selected_month_result = {}
    from_month = @from_month.to_i
    from_year = @from_year.to_i
    to_date = Date.civil(@to_year.to_i, @to_month.to_i)
    while Date.civil(from_year, from_month) <= to_date
        @month = from_month
        @year = from_year
        @selected_month_result[Date.civil(from_year, from_month)] = get_range_wise( "customer" )
        from_month += 1
        if from_month > 12
          from_month = 1
          from_year += 1
        end
    end
    @selected_month_result = @selected_month_result.sort
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
  end

  def monthwise_promotion_report
    @result = get_range_wise( "promotion" )
    total_result=@result["total"]
    @result.delete_if{|key,value| key == "total"}
    add_hash=Hash.new
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
    unless params[:sort].blank?
      if params[:orderby] =='asc'
        @result = sort_result(@result,params[:sort]) 
      else
        @result = sort_result_desc(@result,params[:sort]) 
      end
    else 
      if params[:orderby] =='asc'
         @result = sort_result_by_name(@result)
      else 
        @result = sort_result_by_name_desc(@result)
      end
    end
    add_hash={"total"=>total_result}
    @result << add_hash
  end

  def selected_monthwise_promotion_report
    @selected_month_result = {}
    from_month = @from_month.to_i
    from_year = @from_year.to_i
    to_date = Date.civil(@to_year.to_i, @to_month.to_i)
    while Date.civil(from_year, from_month) <= to_date
        @month = from_month
        @year = from_year
        @selected_month_result[Date.civil(from_year, from_month)] = get_range_wise( "promotion" )
        from_month += 1
        if from_month > 12
          from_month = 1
          from_year += 1
        end
    end
    @selected_month_result = @selected_month_result.sort
    params[:orderby] == 'desc' ? @orderby = 'asc' : @orderby = 'desc'
  end

  def daywise_order_report
    @result = {}
    if params[:day].blank?
        @days = Date::DAYNAMES
        @stops = Stop.find(:all, :joins => [:requests], :conditions => ["MONTH(stops.date) = ? AND YEAR(stops.date) = ? AND requests.for='pickup'", @month, @year])
    else
        @days = []
        first_day = Date.civil(@year.to_i, @month.to_i)
        while Date::DAYNAMES[first_day.wday] != params[:day]
            first_day = first_day.next
        end
        while first_day.month.to_s == @month

            @days << first_day
            first_day += 7.day
        end
        @stops = Stop.find(:all, :joins => [:requests], :conditions => ["stops.date IN (?) AND requests.for='pickup'", @days])
    end
    windows = Window.find(:all, :conditions => 'regular = TRUE')
    @days.each do |day|
        @result[day] = {}
        windows.each do |window|
            @result[day][window.id.to_s] = 0
        end
        @result[day]["total"] = 0
    end
    unless @stops.blank?
        @stops.each do |stop|
            @days.each do |day|
                if day == stop.date || ( params[:day].blank? && day == Date::DAYNAMES[stop.date.wday] )
                  @result[day][stop.window_id.to_s] += 1
                  @result[day]["total"] += 1
                end
            end
        end
    end
  end

  def monthwise_recurring_order_report
    selected_date=Date.civil(@year.to_i, @month.to_i,-1 )
    weekly_date = (selected_date.to_date-(91)).strftime("%Y-%m-%0e")
    every_other_date = (selected_date.to_date-(161)).strftime("%Y-%m-%0e")
    monthly_date = (selected_date.to_date-(301)).strftime("%Y-%m-%0e")
    @recurring_order_weekly = RecurringOrder.retrive_order_for_reporting(7,weekly_date,selected_date) 
    @recurring_order_other_week = RecurringOrder.retrive_order_for_reporting(14,every_other_date,selected_date) 
    @recurring_order_month = RecurringOrder.retrive_order_for_reporting(28,monthly_date,selected_date) 

  end

  def month_rangewise_order_report
    @selected_month_result = {}
    from_month = @from_month.to_i
    from_year = @from_year.to_i
    to_date = Date.civil(@to_year.to_i, @to_month.to_i)
    while Date.civil(from_year, from_month) <= to_date
        @month = from_month
        @year = from_year
        @windows = Window.find(:all, :conditions => 'regular = TRUE')
        @selected_month_result[Date.civil(from_year, from_month)] = get_range_wise_order()
        from_month += 1
        if from_month > 12
          from_month = 1
          from_year += 1
        end
    end
    @selected_month_result = @selected_month_result.sort
  end

  def get_range_wise_order
    @result = {}
    @stops = Stop.find(:all, :joins => [:requests], :conditions => ["MONTH(stops.date) = ? AND YEAR(stops.date) = ? AND requests.for='pickup'", @month, @year])
    @windows.each do |window|
        @result[window.id.to_s] = 0
    end
    @result["total"] = 0

    unless @stops.blank?
        @stops.each do |stop|
            @result[stop.window_id.to_s] += 1
            @result["total"] += 1
        end
    end
    @result
  end

  private
  def set_date(date=params[:date])
    if date
      @month = date["select(2i)"]
      @year = date["select(1i)"]
      session[:month] = @month
      session[:year] = @year
    elsif  !session[:month].blank?
        @month = session[:month]
        @year = session[:year]
    else
      @month = Date.today.month.to_s
      @year = Date.today.year.to_s
      session[:month]=@month
      session[:year]=@year
    end
  rescue Exception
    @month = Date.today.month.to_s
    @year = Date.today.year.to_s
    flash[:error] = "Invalid date"
  end

  def set_date_range
    if params[:from_date]
        @to_month = params[:to_date]["select(2i)"].to_s
        @to_year = params[:to_date]["select(1i)"].to_s
        past_date = Date.civil(params[:from_date]["select(1i)"].to_i, params[:from_date]["select(2i)"].to_i) - 1.month
        @from_month = past_date.month.to_s
        @from_year = past_date.year.to_s
        session[:to_month] = @to_month
        session[:to_year] = @to_year
        session[:from_month] = @from_month
        session[:from_year] = @from_year
   elsif !session[:to_month].blank?
        @to_month = session[:to_month] 
        @to_year =  session[:to_year]
        @from_month = session[:from_month] 
        @from_year = session[:from_year]  
    else
        @to_month = Date.today.month.to_s
        @to_year = Date.today.year.to_s
        past_date = Date.today - 6.month
        @from_month = past_date.month.to_s
        @from_year = past_date.year.to_s
        session[:to_month] = @to_month
        session[:to_year] = @to_year
        session[:from_month] = @from_month
        session[:from_year] = @from_year
    end
  rescue Exception
    @month = Date.today.month.to_s
    @year = Date.today.year.to_s
    flash[:error] = "Invalid date"
  end

  def get_monthly( type )
    requests = Request.find(:all, :joins => [:order, :stop], :conditions => ["MONTH(stops.date) = ? AND YEAR(stops.date) = ? AND requests.for='delivery' AND orders.status = 'delivered'", @month, @year])
    @result = {}
    @result["total"] = {}
    @result["total"][:unit] = 0.00
    @result["total"][:total_plant] = 0.00
    @result["total"][:total_retail] = 0.00
    @result["total"][:total_margin] = 0.00
    @result["total"][:margin_percent] = 0.00
    unless requests.blank?
        requests.each do |request|
            order_items = request.order.order_items
            order_items.each do |order_item|
                customer_item = order_item.customer_item
                @service_id = order_item.service_id.to_s
                if type=="item_type"
                    @id = customer_item.item_type.name.to_s
                elsif type=="service"
                    @id = order_item.service.name.to_s
                end
                previous_result = @result[@id]
                if previous_result.blank?
                    @result[@id] = {}
                    @result[@id][:unit] = 0
                    @result[@id][:total_plant] = 0
                    @result[@id][:total_retail] = 0
                    @result[@id][:total_margin] = 0
                    @result[@id][:margin_percent] = 0
                    @result[@id][:lbs_weight] = 0 if @service_id == '1'
                end
#                 if customer_item.plant_price.to_f > 0.00
                    @result[@id][:unit] += 1
                    @result["total"][:unit] += 1
                    plant_price = order_item.plant_price
                    @result[@id][:lbs_weight] += order_item.get_weight if @service_id == '1'
                    @result[@id][:total_plant] += (plant_price + customer_item.plant_extra_charge)
                    @result["total"][:total_plant] += (plant_price + customer_item.plant_extra_charge)
                    retail_price = order_item.price
                    @result[@id][:total_retail] += (retail_price + customer_item.extra_charge)
                    @result["total"][:total_retail] += (retail_price + customer_item.extra_charge)
                    @result[@id][:total_margin] = (@result[@id][:total_retail].to_f - @result[@id][:total_plant].to_f)
                    @result["total"][:total_margin] = (@result["total"][:total_retail].to_f - @result["total"][:total_plant].to_f)
                    @result[@id][:margin_percent] = (@result[@id][:total_margin].abs * 100)/@result[@id][:total_plant].to_f
#                 end
            end
        end
    end
    @result
  end

  def get_range_wise( type )
    requests = Request.find(:all, :joins => [:order, :stop], :conditions => ["MONTH(stops.date) = ? AND YEAR(stops.date) = ? AND requests.for='delivery' AND orders.status = 'delivered'", @month, @year])
    @result = {}
    @result["total"] = {}
    @result["total"][:unit] = 0.00
    @result["total"][:total_plant] = 0.00
    @result["total"][:total_retail] = 0.00
    @result["total"][:total_margin] = 0.00
    @result["total"][:margin_percent] = 0.00
    unless requests.blank?
        requests.each do |request|
            order = request.order
            customer = order.customer
            if type=="promotion"
                next if order.promotion_id.blank?
                @id = order.promotion.code.to_s 
            elsif type=="customer"
                @id = customer.name.to_s
            end

            unless customer.blank?
                previous_result = @result[@id]
                if previous_result.blank?
                    @result[@id] = {}
                    @result[@id][:unit] = 0
                    @result[@id][:total_plant] = 0
                    @result[@id][:total_retail] = 0
                    @result[@id][:total_margin] = 0
                    @result[@id][:margin_percent] = 0
                end
                @result[@id][:unit] += 1
                @result["total"][:unit] += 1
                order.order_items.each do |order_item|
                    customer_item = order_item.customer_item
#                     if customer_item.plant_price.to_f > 0.00
                        is_premium = ( order_item.order.premium || customer_item.premium || order_item.premium )
                        price = Price.find(:first, :conditions => ["service_id = ? AND item_type_id = ? ", order_item.service_id, customer_item.item_type_id])
                        plant_price = order_item.plant_price
                        @result[@id][:total_plant] += (plant_price + customer_item.plant_extra_charge)
                        @result["total"][:total_plant] += (plant_price + customer_item.plant_extra_charge)
                        retail_price = order_item.price
                        @result[@id][:total_retail] += (retail_price + customer_item.extra_charge)
                        @result["total"][:total_retail] += (retail_price + customer_item.extra_charge)
                        @result[@id][:total_margin] = (@result[@id][:total_retail].to_f - @result[@id][:total_plant].to_f)
                        @result["total"][:total_margin] = (@result["total"][:total_retail].to_f - @result["total"][:total_plant].to_f)
                        @result[@id][:margin_percent] = (@result[@id][:total_margin].abs * 100)/@result[@id][:total_plant].to_f
#                     end
                end
            end
        end
    end
    @result
  end

  def sort_result(target_hash,sorting_element)
    temp_hash=Hash.new({})
    sort_array=Array.new
    target_hash.each do |key,val|
      temp_hash.merge!(key => val[sorting_element.to_sym].to_f)
    end
    temp_hash=temp_hash.sort{|key,value| key[1]<=>value[1] }
    temp_hash.each do |element|
      sort_array.push({element[0]=>target_hash[element[0]]})
    end
    return sort_array
  end

  def sort_result_desc(target_hash,sorting_element)
      temp_hash=Hash.new({})
      sort_array=Array.new
      target_hash.each do |key,val|
        temp_hash.merge!(key => val[sorting_element.to_sym].to_f)
      end
      temp_hash=temp_hash.sort{|key,value| value[1]<=>key[1] }
      temp_hash.each do |element|
        sort_array.push({element[0]=>target_hash[element[0]]})
      end
      return sort_array
  end


  def sort_result_by_name(target_hash)
    temp_hash=target_hash
    sort_array=Array.new
    temp_hash=temp_hash.sort
    temp_hash.each do |element|
      sort_array.push({element[0]=>target_hash[element[0]]})
    end
    return sort_array
  end

  def sort_result_by_name_desc(target_hash)
    temp_hash=target_hash
    sort_array=Array.new
    temp_hash=temp_hash.sort{|x,y| y <=> x }
    temp_hash.each do |element|
      sort_array.push({element[0]=>target_hash[element[0]]})
    end
    return sort_array
  end

end
