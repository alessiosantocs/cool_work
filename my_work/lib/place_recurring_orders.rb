RecurringOrder.find(:all).each do |ro|
  puts "Placing next for recurring order id: #{ro.id}"
  ro.place_next
end