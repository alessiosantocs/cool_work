namespace :cron do
  desc "Update days left for each party"
  task :update_days_left => :environment do
    now_date = 0.day.ago.utc
    yesterday = now_date.yesterday.to_formatted_s(:db)
    now = now_date.to_formatted_s(:db)
    
    #expired parties
    puts "Finding expired parties (after #{now})..."
    expired_events = Event.find(:all,
      :conditions => "events.active=1 AND parties.active=1 AND UNIX_TIMESTAMP(events.happens_at) <= #{now_date.to_i}",
      :order => 'events.id desc',
      :include => [:party] )
    puts "Events Found: #{expired_events.length}\n"
    expired_events.each do |e|
      current_event = e.party.event rescue nil
      puts "(#{e.happens_at.to_formatted_s(:db)}) #{e.party.title} at #{e.venue.name} has #{e.party.total_days} days left."
      #one-time events OR events whose last date just passed.
      e.update_attribute(:active, false)
      if e.party.recur == "no" or ((now_date.to_i > e.party.end_date.to_i) and (e.party.end_date != nil))
        e.party.update_attribute(:active, false)
      elsif e.party.end_date == nil or e.party.end_date.to_i > now_date.to_i
        puts "create new event id (#{e.party_id})"
        e.party.create_new_event
      end
      unless current_event.nil?
        current_event.toggle!(:active)
      end
    end
    
    #parties that expire in a days time
    puts "Updating days left..."
    parties_with_one_day_left = Party.find(:all, 
      :select => "parties.days_free as total_days, parties.current_event_id, parties.title, parties.premium, venues.name, users.email", 
      :conditions => "(parties.days_free=1) AND parties.recur !='no' AND parties.active=1 AND last_time_cron <= '#{yesterday}'",
      :include => [:venue, :user] )
    puts "Parties Found: #{parties_with_one_day_left.length}"
    parties_with_one_day_left.each do |p|
      if p.total_days == 1
        p.event.update_attribute(:active, false)
        Notifier::deliver_expiring_party(p, p.total_days) #send emails to clients informing them that party is on last day.
      end
    end
    
    puts "Set all last_time_cron to created_on if NULL"
    Party.update_all("last_time_cron = parties.created_on", "last_time_cron is NULL")
    
    puts "Decreased all paid days by one, if no free days left"
    Party.update_all("days_paid = days_paid - 1, last_time_cron='#{now}'", "days_free=0 AND active=1 AND last_time_cron <= '#{yesterday}'")
    
    puts "Decreased all free days by one"
    Party.update_all("days_free = days_free - 1, last_time_cron='#{now}'", "days_free > 0 AND active=1 AND last_time_cron <= '#{yesterday}'")
    
    puts "Deactivated all events with days free and days paid are empty"
    Party.update_all("active=0, last_time_cron='#{now}'", "days_free=0 AND days_paid=0 AND active=1")
  end
  
  desc "create most viewed by event and date"
  task :most_viewed_for_site => :environment do
    limit = 25
    time_frame = 1.day.ago
    directory = File.expand_path(RAILS_ROOT+'/public/javascripts/ranked')
    #Generate top views by region
    REGIONS.each do |r|
      file = directory + "/region_#{r.id}.js"
      views = Stat.most_views_by_type(r, time_frame, 25)
      File.open(file, "w") do |f|
        f.write("var images = #{views.to_json};")
      end
    end
    #Generate top views for the site
    file = directory + "/site.js"
    views = Stat.most_views_by_type(SITE, time_frame, 25)
    File.open(file, "w") do |f|
      f.write("var images = #{views.to_json};")
    end
  end
end