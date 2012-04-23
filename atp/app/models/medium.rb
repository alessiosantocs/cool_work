require "mini_magick"
EXTENSIONS = {
  "image/jpeg" => ["jpg", "jpeg", "jpe"],
  "image/gif" => ["gif"],
  "image/png" => ["png"]
}

class Medium < ActiveRecord::Base
  belongs_to :user
  belongs_to :image_set
  has_many :flags, :as => :obj, :dependent => :destroy
  belongs_to :obj, :polymorphic => true
  has_one :ad
  acts_as_taggable
  acts_as_rateable
  acts_as_voteable
  validates_presence_of       :user_id
  validates_length_of         :caption, :within => 3..225, :allow_nil => true
  attr_accessor :file, :path, :url
  @@img_size = SETTING["image"]
  
  def watermark(src,dest)
    return system("composite -gravity NorthEast -geometry +10+10 #{SETTING['image']['watermark']} '#{src}' #{dest}")
  end
  
  protected
  def process_file
    return "File does not exist!" if file.class.to_s == 'String'
    result = EXTENSIONS.find{|k,v| k == file.content_type.strip }
    return "Bad file type: #{file.content_type}." if result.nil?
    extension = result[1].first
    file_path = file.path
    filename = self.create_path('local')
    if file.class.to_s == 'StringIO' 
      File.open(file_path, 'w'){ |f| file.seek(0); filename.each{ |l| f<<l } } #copy file
      return true
    else
      new_img = MiniMagick::Image.from_file(file_path)
      self.width, self.height = new_img[:width], new_img[:height]
      begin
        s = SETTING["image"]
        case self.class.to_s
          when 'Photo'
            ["full", "med"].each do |size|
              sf = s[size]
              resize(file_path,self.create_path('local', size),"#{sf['width']}x#{sf['height']}")
            end
            ["thumb", "tiny"].each do |size|
              st = s[size]
              crop(new_img, st['width'], st['height'], file_path, self.create_path('local', size))
            end
            return true
          when 'Flyer'
            ["full", "med"].each do |size|
              sf = s["flyer_#{size}"]
              resize(file_path,self.create_path('local', size),"#{sf['width']}x#{sf['height']}")
            end
            st = s["flyer_thumb"]
            crop(new_img, st['width'], st['height'], file_path, self.create_path('local'))
            return true
          else
            #original
            FileUtils.cp file_path, filename #copy file
            return true
        end
      rescue Exception => err
        stmt = 'cannot be processed.  Please try again. (' + err + ')'
        return stmt
      end
    end
  end
end

class AdImage < Medium
  has_attachment :storage => :s3, 
    :path_prefix => "AdImage", 
    :content_type => :image,
    :max_size => 100.kilobytes
  validates_as_attachment
end

class Cover < Medium
  has_attachment :storage => :s3, 
    :path_prefix => "Cover", 
    :content_type => :image,
    :resize => "#{@@img_size['cover']}>",
    :max_size => 250.kilobytes
  validates_as_attachment
end

class Photo < Medium
  @@img_size = SETTING["image"]
  has_attachment :storage => :s3, 
    :path_prefix => "Photo", 
    :content_type => :image,
    :max_size => 3.megabytes,
    :thumbnails => { 
      :tiny => "#{@@img_size['tiny']}>", 
      :thumb => "#{@@img_size['thumb']}>", 
      :med => "#{@@img_size['med']}>", 
      :full => "#{@@img_size['full']}>" }
  validates_as_attachment
  
  def to_json(*args)
    {
		 :id  => self.id,
		 :caption  => self.caption,
		 :tiny  => self.public_filename(:tiny),
		 :thumb  => self.public_filename(:thumb),
		 :med  => self.public_filename(:med),
		 :full  => self.public_filename(:full)
		}.to_json
  end
end

class Flyer < Medium
  @@img_size = SETTING["image"]
  has_attachment :storage => :s3, 
    :path_prefix => "Flyer", 
    :content_type => :image,
    :max_size => 2.megabytes,
    :thumbnails => { 
      :thumb => "#{@@img_size['flyer_thumb']}>", 
      :med => "#{@@img_size['flyer_med']}>", 
      :full => "#{@@img_size['flyer_full']}>" }
    
  validates_as_attachment
end

class PartyFlyer < Flyer; end
class EventFlyer < Flyer; end
# class Music < Medium
#   
# end

# class Video < Medium
#   
# end