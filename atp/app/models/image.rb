require "mini_magick"
class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :image_set
  has_many :flags, :as => :obj, :dependent => :destroy
  has_many :stats, :as => :obj, :dependent => :destroy
  has_one :ad
  acts_as_taggable
  acts_as_rateable
  acts_as_voteable
  validates_presence_of       :user_id, :server, :path, :name, :url
  validates_length_of         :caption, :within => 3..75, :allow_nil => true
  
  def self.blank(options={})
    new({ :comments_allowed => true }.merge(options))
  end
  
  def link(size=nil, secure='false')
    "#{url}#{name}" + (size.nil? ? '' : '_' + size ) + SETTING['image_server']['extension']
  end
  
  def self.find_dimensions(w,h)
    find(:first, :conditions=> ["width=? and height=?", w,h])
  end
  
  def flyer
    return self if width == Image.flyer[0] and height == Image.flyer[1]
    if self.parent_id.nil?
      child = self.children.find_dimensions(Image.flyer[0],Image.flyer[1])
      return child
    else
      return nil
    end
  end
  
  def self.get_size(size)
    return [SETTING['image'][size]['width'], SETTING['image'][size]['height']]
  end
  
  def self.tiny
    return [SETTING['image']['tiny']['width'], SETTING['image']['tiny']['height']]
  end
  
  def self.small
    return [SETTING['image']['small']['width'], SETTING['image']['small']['height']]
  end
  
  def self.large
    return [SETTING['image']['large']['width'], SETTING['image']['large']['height']]
  end
  
  def self.cover_image
    return [SETTING['image']['cover_image']['width'], SETTING['image']['cover_image']['height']]
  end
  
  def self.flyer
    return [SETTING['image']['flyer']['width'], SETTING['image']['flyer']['height']]
  end

	def self.store(temp_pic, image_type, img_path, img_base_url, user_id)
		new_filename = generate_challenge(6) #create a random filename
		s = SETTING['image'] #shorten setting constant
    watermark = true
		case image_type
		  when 'Ad'
		    image_array = ['flyer', 'banner_336x280']
		    watermark = false
		  when 'User'
		    image_array = ['small', 'large', 'tiny']
		  when 'Event'
		    image_array = ['small', 'large', 'tiny']
		  when 'CoverImage'
		    image_array = ['cover_image']
		    watermark = false
		  when 'Flyer'
		    image_array = ['flyer', 'large', 'tiny']
		    watermark = false
		  else
		    return
		end
		
		# create original image
		original_image = process_img(temp_pic, {
		  :watermark => false,
			:server => SETTING['image_server']['host'], 
			:path => img_path, 
			:extension => SETTING['image_server']['extension'],  
			:size => nil,
			:name => new_filename})
		if original_image.class.to_s == 'Hash'
			original_image_obj = add_image_to_db(original_image, img_base_url, user_id)
		else
		  return original_image
		end
		
		# Create additional images from image_array
		image_array.each do |size|
			process_img(temp_pic, {
			  :watermark => watermark,
				:server => SETTING['image_server']['host'], 
				:path => img_path,  
				:name => new_filename,
				:size => size,
				:width => s[size]['width'],
				:height => s[size]['height'] })
		end
		return original_image_obj
	end
	
	def self.add_image_to_db(img, img_base_url, user_id)
		i = Image.blank({
      :user_id => user_id,
      :server => SETTING['image_server']['host'],
      :path => img[:path],
      :url => img_base_url,
      :name => img[:name]
		})
		i.save
		i
	end
	
	private
  def before_destroy
    begin
      system("rm -f #{self.path}/#{self.name}_*#{SETTING['image_server']['extension']}")
      system("rm -f #{self.path}/#{self.name}#{SETTING['image_server']['extension']}")
    rescue Errno::ENOENT
    end
  end
  
  # def save2s3(file)
  #   @conn ||= AWS::S3::Base.establish_connection!(
  #     :access_key_id     => S3[:access_key_id],
  #     :secret_access_key => S3[:secret_access_key]
  #   )
  #   S3Storage.store(file, open(file), {})
  # end

  def self.process_img(file, img={}, opt={})
    return "File does not exist!" if file.nil?
    watermark = false #default
    begin
      new_img = MiniMagick::Image.from_file(file)
      max = {:width=> SETTING['image']['max']['width'], :height=> SETTING['image']['max']['height']}.merge(opt)
      actual_img = img[:path]+img[:name]+(img[:size].nil? ? '' : '_' + img[:size] )+SETTING['image_server']['extension']
      case img[:size]
        when "small", "tiny", "flyer"
          #crop to box
          return crop(new_img, img[:width], img[:height], file, actual_img)
        when "cover_image", "banner_336x280"
          #resize and no watermark
          resize(file,actual_img,"#{img[:width]}x#{img[:height]}")
        when "large"
          #resize and watermark
          resize(file,actual_img,"#{img[:width]}x#{img[:height]}")
          return watermark(actual_img, actual_img)
        else
          #original
          FileUtils.cp file, actual_img #copy file
          return img
      end
    rescue Exception => err
      return "Could not process your image file.  Please try again. (#{err})"
    end
  end

  def self.watermark(src,dest)
    return system("composite -gravity NorthEast -geometry +10+10 #{SETTING['image']['watermark']} '#{src}' #{dest}")
  end

  def self.resize(src,dest,size)
    return system("convert -strip -quality 85 -size #{size} '#{src}' -resize #{size} #{dest}")
  end

  def self.crop(img, w, h, src, dest)
    size = "#{w}x#{h}+0+0"
    resize = ( img[:width] > img[:height] ? "x#{h}" : "#{w}x" )
    return system("convert -quality 85 -strip -size #{resize} '#{src}' -resize #{resize} #{dest} && mogrify -gravity North -crop #{size} #{dest}")
  end
end