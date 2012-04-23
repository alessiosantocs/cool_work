module OrdersHelper
  def selected_reccuring_pick(rec_order, day)
    val = "value='#{day}'"
    if rec_order && rec_order.pickup_day == day 
      val += "selected='selected'"
    end
    val
  end
  
  def selected_reccuring_del(rec_order, day)
    val = "value='#{day}'"
    if rec_order && rec_order.delivery_day == day 
      val += "selected='selected'"
    end
    val
  end
  
  def selected_window_pick(rec_order, window)
    val = "value='#{window.id}'"
    if rec_order && rec_order.pickup_time == window.id 
      val += "selected='selected'"
    end
    val
  end
  
  def selected_window_del(rec_order, window)
    val = "value='#{window.id}'"
    if rec_order && rec_order.delivery_time == window.id 
      val += "selected='selected'"
    end
    val
  end
  
  def selected_interval(rec_order, interval)
    val = "value='#{interval}'"
    if rec_order && rec_order.interval == interval 
      val += "selected='selected'"
    end
    val
  end  
end
