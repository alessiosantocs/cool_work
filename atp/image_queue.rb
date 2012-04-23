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
require 'fileutils'
require 'config/boot'
require 'config/environment'
require "mini_magick"
class ImageQueue
  def initialize(options={})
    @uploads = File.expand_path(options[:uploads])
    @scratch = File.expand_path(options[:scratch])
    @sleep = options[:sleep] || 30
  end

  def work_loop
    loop {
      puts "#{Time.now.utc}: loop began"
      grab_new_uploads.each do |zipfile|
        puts "#{Time.now.utc}: #{zipfile} began"
        @filename,@file_type = File.basename(zipfile).split(/\./)
        type,@id,@user_id = @filename.split(/_/)
        rec = type.camelize.constantize.find(@id)
        upload(rec,zipfile) unless rec.nil?
        BgTask.completed(type,@id,@user_id)
        puts "#{Time.now.utc}: #{zipfile} ended"
        FileUtils.rm zipfile
      end
      s = Site.find SITE_ID
      puts "#{Time.now.utc}: loop ended"
      sleep @sleep
    }
  end
  alias :run :work_loop
  
  # grab the latest uploads and move them to the scratch
  # dir so they are out of the uploads dir the next time around.
  def grab_new_uploads
    new_uploads = []
    Dir["#{@uploads}/*"].each do |zip|
      dest = File.join(@scratch, File.basename(zip))
      FileUtils.mv zip, File.join(@scratch, File.basename(zip))
      new_uploads << dest
    end
    new_uploads
  end
  
	def add_image_to_event(event,image, position)
		e = event.image_sets.create({
			:image_id => image.id,
			:comments_allowed => image.comments_allowed,
			:position => position
		})
	end
	
  def upload(event, file)
	  if event.party.past_events.empty?
	    puts "No past events exist yet."
	    return false
	  end
		errors = []
		images = %r/jpg|jpeg|png/i
		last_postition = event.image_sets.length || 0

		if event.picture_uploaded or event.party.pics_left > 0
			img_path = SETTING['image_server']['path']+"/party/#{event.party_id}/#{event.id}/" # create image directory path
			img_base_url = SETTING['image_server']['base_url']+"/party/#{event.party_id}/#{event.id}/"
			FileUtils.mkdir_p(img_path)			
			fc = FileCollection.new(file, @filename.sub(/.*?((\.tar)?\.\w+)$/, '\1')).process
			fc.find(images).each do |f|
				@image = Image.store(f, 'Event', img_path, img_base_url, @user_id)
				if @image.class.to_s == 'Image'
  				last_postition += 1
  				add_image_to_event(event, @image, last_postition)
				else
				  errors << @image
				end
			end
			fc.delete

			if errors.length > 0
			  puts errors.join('. ')
			else  
			  event.update_image_set_count
			end
		end
  end
  
  def restart_upload
    system "mv #{BASE_PATH}/public/system/scratch/* #{BASE_PATH}/public/system/upload/"
  end
end


t = ImageQueue.new :uploads => BASE_PATH + SETTING['image_server']['upload_dir'].sub(/[.]/, ''),
               :scratch => BASE_PATH + SETTING['image_server']['scratch_dir'].sub(/[.]/, ''),
               :sleep   => 120
begin
  t.run
rescue Exception => e
  puts "\n\n#{ e.message } - (#{ e.class })" << "\n" << (e.backtrace or []).join("\n")
ensure
  t.restart_upload
end
puts "loop ended at #{Time.now.utc}" 