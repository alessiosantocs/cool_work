desc "Send out weekly emails" 
task :send_weekly_emails => :environment do
    TaskLog.post("send_weekly_emails","loading","weekly emails begins")
    #create idmod7
    User.update_all("idmod7=id MOD 7", "idmod7 is NULL")
	logfile = File.expand_path(RAILS_ROOT+"/log/email/#{Time.now.strftime('%Y%m%d')}_#{Time.now.wday}.log")
	@profiles = User.find(:all, :select=>'id,username,email,security_token', :conditions=>"idmod7=#{Time.now.wday} and verified=1 AND receive_general_notification=1")
	File.open(logfile, "w") do |f| 
    	@profiles.each do |user|
    	   user_fave = FavoritePlace.by_user(user.id) || []
    	   new_testimonials = TestimonialT.total_unapproved(user.id) || []
    	   new_messages = Msg.total_unread_msgs(user.username) || []
    	   friend_requests = User.relations(user.id, "unapproved")
    	   UserMailer::deliver_weekly(user, user_fave, new_testimonials, new_messages, friend_requests)
    	   f.write("#{user.id},#{user.email},#{Time.now}\n");
    	end
     end
     system "gzip -f #{logfile}"
     TaskLog.post("send_weekly_emails","success","#{@profiles.size} emails sent")
end

desc "google sitemap generator"
task :sitemap => :environment do
	unless TaskLog.ran_today?("sitemap")
		TaskLog.post("sitemap","loading","Site mapping begins")
		include Utils
		sitemap_file = File.expand_path(RAILS_ROOT+'/public/sitemap.xml')
		lastmod = Time.now.strftime("%Y-%m-%d")
		places = Place.find(:all, :select=>'id, name, city, state, country', :conditions=>'live=1')
		File.open(sitemap_file, "w") do |f|
			f.write("<?xml version='1.0' encoding='UTF-8'?><urlset xmlns='http://www.google.com/schemas/sitemap/0.84' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.google.com/schemas/sitemap/0.84 http://www.google.com/schemas/sitemap/0.84/sitemap.xsd'>")
			places.each do |p|
				f.write("<url><loc>http://www.scenestr.com/place/#{p.id}?name=#{urlencode(p.name)}&amp;city=#{urlencode(p.city)}&amp;state=#{urlencode(p.state)}&amp;country=#{urlencode(p.country)}</loc><lastmod>#{lastmod}</lastmod><changefreq>daily</changefreq></url>")
			end
			f.write("</urlset>")
		end
		system "gzip -f #{sitemap_file}"
		TaskLog.post("sitemap","success","Site mapping complete")
	else
		puts "Ran today already!" 
	end
end

desc "backup_site"
task :backup_site => :environment do
	unless TaskLog.ran_today?("backup_site")
		def rsync(local_path, remote_dir)
			if system("rsync -avz #{local_path} #{REMOTE}#{remote_dir}/ --exclude '.log' --exclude '.svn' --exclude '.cache'")
				return true
			else
				return false
			end
		end
		TaskLog.post("backup_site","loading","Site backup begins")
		REMOTE = 'fcginc@fcginc.strongspace.com:/home/fcginc/'
		if rsync(File.expand_path(RAILS_ROOT), 'rails')
			TaskLog.post("backup_site","success","Site backed up completely uploaded")
		else
			TaskLog.post("backup_site","failure","Site not uploaded")
		end
	else
		puts "Ran today already!" 
	end
end

desc "Daily Stats" 
task :create_daily_fave_stats => :environment do
	#This task occurs daily, so let's check if it has occured today successfully
	if TaskLog.ran_today?("create_daily_fave_stats")
		puts "Ran today already!" 
	else	
	  begin
		  TaskLog.post("create_daily_fave_stats","loading","Creating Daily Stats")
			offset = 0
			limit = 250
			#get total # of places
			total_record_count = Place.count
			#select all places
			while offset < total_record_count
				records = Place.find(:all, :select=>'id', :offset=>offset, :limit=>limit )
				#for each place
				records.each do |r|
					user_count = {
						'Sun'=>0,
						'Mon'=>0,
						'Tue'=>0,
						'Wed'=>0,
						'Thu'=>0,
						'Fri'=>0,
						'Sat'=>0,
						'RES'=>0
					}
					circle_count = {
						'Sun'=>0,
						'Mon'=>0,
						'Tue'=>0,
						'Wed'=>0,
						'Thu'=>0,
						'Fri'=>0,
						'Sat'=>0,
						'RES'=>0
					}
					faves = FavoritePlace.find_place_faves(r.id)
					unless faves.empty?
						faves.each do |f|
							node = f.day_of_the_week
							node = 'RES' if f.day_of_the_week.nil?
							unless f.circle_id.nil?
								#tally faves for circles
								circle_count[node] += 1
							else
								#tally faves for users
								user_count[node] += 1
							end
						end
						#insert into fave_stats table
						queries = Array.new
						circle_count.each_pair do | k,v | 
							# skip if both are empty
							unless v == 0 and user_count[k]==0
								if k=='RES' #make day value null for restaurant
									day="'---'"
								else
									day="'#{k}'"
								end
								queries << "(NULL,#{r.id},#{user_count[k].to_i},#{v},#{day},CURDATE())"
							end
						end
						if queries.length > 0
							#insert array in bulk
							FaveStat.bulk_insert(queries)
						end
					end
				#insert fave count if fave count > 0
				end
				offset += limit
			end
		  TaskLog.post("create_daily_fave_stats","success","Finished creating Daily Stats")
	  rescue
	  	TaskLog.post("create_daily_fave_stats","failure","Daily Stats Interuption...")
	  end
	end
end