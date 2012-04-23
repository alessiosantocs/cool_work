module Admin::ScheduleHelper
  
  def containment(trucks)
    containment = Array.new
    containment << "order-info"
    trucks.each do |truck|
        containment << "truck_"+truck.id.to_s
    end
    return containment
  end
  
  def schedules_heat(schedules)
    heat = {}
    first_weekday.upto(last_weekday) do |day| 
      heat[day.day.to_s+'/'+day.month.to_s] = heat_color(schedules[day].heat)
    end
    heat.to_json
  end
  
  private
  def heat_color(ratio)
    percentage = ratio * 100
    color = '#80B442'
    if percentage > 33 && percentage <= 66
      color = '#FCFBE6'
    end
    if percentage > 66
      color = '#CC3333'
    end
    color
  end
end