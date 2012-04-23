if File.directory? '/data/frstclan/current'
  BASE_PATH = "/data/frstclan/current"
  ENV['RAILS_ENV'] = 'production'
elsif File.directory? "/Users/onyekwelu/workspace/atp/trunk"
  BASE_PATH = "/Users/onyekwelu/workspace/atp/trunk"
  ENV['RAILS_ENV'] = 'development'
else
  puts "look at current directories listed here and make changes"
  exit
end
require 'config/boot'
require 'config/environment'
class OrderImagesets
  def initialize(options={})
    @limit = options[:limit] || 100
    @sleep = options[:sleep] || 5
    @last_event_id = options[:start] || 1
  end

  def work_loop
    loop {
      puts "loop started at #{Time.now}"
      events = Event.find(:all, :conditions => "picture_uploaded > 0 and id > #{@last_event_id}", :limit => @limit)
      if events.size == 0
        puts "Last event id is #{@last_event_id}."
        break
      end
      events.each do |event|
        pos=0
        event.image_sets.each { |i| i.update_attribute(:position, pos += 1) }
        @last_event_id = event.id
        puts "completed ev #{@last_event_id}"
      end
      puts "loop ended at #{Time.now}"
      sleep @sleep
    }
  end
  alias :run :work_loop
end

# t = OrderImagesets.new(:limit => 250, :sleep => 3, :start => 1)
# begin
#   t.run
# rescue Exception => e
#   puts "\n\n#{ e.message } - (#{ e.class })" << "\n" << (e.backtrace or []).join("\n\n")
# end
# puts "loop ended at #{Time.now}"