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
class ResizeImgs
  def initialize(options={})
    @limit = options[:limit] || 100
    @sleep = options[:sleep] || 5
    @last_event_id = options[:start] || 1
    @mod = options[:mod] || 1
  end

  def work_loop
     loop {
      puts "loop started at #{Time.now}"
      events = Event.find(:all, :conditions => "id mod 2 = #{@mod} AND picture_uploaded > 0 and id < #{@last_event_id}", :limit => @limit, :order => 'id desc')
      if events.size == 0
        puts "Last event id is #{@last_event_id}."
        break
      end
      events.each do |event|
        sys = []
        event.image_sets.each do |i|
          files = [
            BASE_PATH + i.image.path.sub('.','') + i.image.name + '_small' + SETTING['image_server']['extension'],
            BASE_PATH + i.image.path.sub('.','') + i.image.name +  '_tiny' + SETTING['image_server']['extension'],
            BASE_PATH + i.image.path.sub('.','') + i.image.name + '_large' + SETTING['image_server']['extension']
          ]
          sys << files.collect{ |m| "convert -quality 85 -strip #{m} #{m}" }
        end  
        #puts sys.join(" && ")
        puts system(sys.join("; "))
        
        @last_event_id = event.id
        puts "completed ev #{@last_event_id}"
      end
      puts "loop ended at #{Time.now}"
       sleep @sleep
    }
  end
  alias :run :work_loop
end
puts "loop began at #{Time.now}"
t = ResizeImgs.new(:limit => 200, :sleep => 3, :start => 20000, :mod => 1)
begin
  t.run
rescue Exception => e
  puts "\n\n#{ e.message } - (#{ e.class })" << "\n" << (e.backtrace or []).join("\n\n")
end
puts "loop ended at #{Time.now}"