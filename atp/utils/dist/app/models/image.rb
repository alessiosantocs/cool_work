require 'RMagick'
CHARS = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :image_set
  has_many :flags, :as => :obj, :dependent => :destroy
  acts_as_tree
  validates_presence_of       :user_id, :server, :path, :name, :width, :height, :url, :size, :extension
  validates_length_of         :caption, :within => 3..75, :allow_nil => true
  
  def self.blank(options={})
    new({}.merge(options))
  end
  
  def link(size=nil)
    url.to_s + name.to_s + (size.nil? ? '' : '_' + size ) + extension.to_s
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

	def self.process_for_storage(temp_pic, image_type, img_path, img_base_url, user_id)
	  new_filename = ""
	  1.upto(6) { |i| new_filename << CHARS[rand(CHARS.size-1)] }
		s = SETTING['image'] #shorten setting constant

		case image_type
		  when 'Event'
		    image_array = ['small', 'large', 'tiny']
		  when 'CoverImage'
		    image_array = ['cover_image']
		  when 'Flyer'
		    image_array = ['flyer', 'large']
		  else
		    return
		end
		
		# create original image
		original_image = process(temp_pic, {
			:server => SETTING['image_server']['host'], 
			:path => img_path, 
			:extension => SETTING['image_server']['extension'],  
			:name => new_filename})
		if original_image.class.to_s == 'Magick::Image'
			@@parent = add_image_to_db(original_image, img_base_url, user_id, true)
		else
		  return original_image
		end
		
		# Create additional images from image_array
		image_array.each do |size|
			new_image = process(temp_pic, {
				:server => SETTING['image_server']['host'], 
				:path => img_path, 
				:extension => SETTING['image_server']['extension'],  
				:name => new_filename + '_' + size,
				:width => s[size]['width'],
				:height => s[size]['height'] })
			if new_image.class.to_s == 'Magick::Image'
				self.add_image_to_db(new_image, img_base_url, user_id)
  		else
  		  return new_image
			end
		end
		return @@parent
	end
	
	def self.add_image_to_db(img, img_base_url, user_id, parent=false)
		name = File.basename(img.filename, SETTING['image_server']['extension'])
		opt = {
			:user_id => user_id, 
			:server => SETTING['image_server']['host'], 
			:path => File.dirname(img.filename),
			:url => img_base_url,
			:extension => SETTING['image_server']['extension'],
			:name => name,
			:size => File.stat(img.filename).size,
			:width => img.columns,
			:height => img.rows
		}
		unless parent
			return @@parent.children.create(opt)
		else
			return create(opt)
		end
	end
	
  def before_destroy
    if parent_id.nil?
      #find children
      all_pics = self.children.to_a + self.to_a
      all_pics.each{|pic| drop(pic) }
    else
      drop(self)
    end
  end
	
	private
  def drop(image)
    begin
      File.delete("#{image.path}/#{image.name}#{image.extension}")
    rescue Errno::ENOENT
    end
  end
  
  def self.process(file, img={}, max={:width=> SETTING['image']['max']['width'], :height=> SETTING['image']['max']['height']})
    return "File does not exist!" if file.nil?
    begin
      new_img = Magick::Image::read(file).first
      return "Image is too big (Height can be bigger than #{max[:height]} and width can't be wider than #{max[:width]}.)" if max[:width] < new_img.columns or max[:height] < new_img.rows
		  new_img.density = "72x72"
    
      #create destination and image dimensions
      img001 = img[:path]+img[:name]+img[:extension]
      if !img[:width].nil? and !img[:height].nil?
        dimensions = "#{img[:width]}x#{img[:height]}"
  		  #Crop only thumbnail sized images
  		  if img[:width] < 150 || img[:height] < 150
  		    new_img = crop(new_img, img[:width], img[:height])
  		  end
        new_img.change_geometry!(dimensions) { |cols, rows, image|
          image.resize!(cols, rows)
        }
      end
      new_img.write(img001){ self.quality = 90 }
    rescue Exception => err
      return 'Could not process your image file.  Please try again. ' + err
    else
      return new_img
    end
  end
  
  def self.crop(img, w, h)
		aspectRatio = w.to_f / h.to_f
		imgRatio = img.columns.to_f / img.rows.to_f
		if img.columns > img.rows
		  img.crop!(Magick::CenterGravity, img.rows, img.rows).scale(h,h)
		else
		  img.crop!(Magick::CenterGravity, img.columns, img.columns).scale(w,w)
		end
		imgRatio > aspectRatio ? scaleRatio = w.to_f / img.columns : scaleRatio = h.to_f / img.rows
    img.resize!(scaleRatio)
    return img
  end

  def self.generate_challenge( len=32, extra=[] )
		len = 32 if len > 32
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + extra # + ['#','.','%','@','*','_']
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    str
	end
end