class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[key.to_sym] = value
      options
    end
  end

  def prepare4db
    inject({}) do |options, (key, value)|
      options[key] = (value.nil? ? 'NULL' : "\"#{value}\"")
      options
    end
  end
end

if File.directory? '/data/frstclan/current'
  ROOT = "/data/frstclan/current"
  ENVIRON = "production"
elsif File.directory? "/Users/onyekwelu/workspace/atp/trunk"
  ROOT = "/Users/onyekwelu/workspace/atp/trunk"
  ENVIRON = "development"
else
  puts "look at current directories listed here and make changes"
  exit
end

require "rubygems"
require 'mysql'
require "yaml"
require 'find'
require 'logger'
require "lib/utils"
require 'aws/s3'
include AWS::S3
include Utils

Mysql::Result.send(:include, Enumerable) #credit to Luke Carlson in http://tech.rufy.com/2007/08/really-useful-ruby-mysql-one-liner.html

DATAFILE = "split.txt"
LOGFILE = "output-#{DATAFILE}.sql"
IMAGE_SWITCH_BOARDS_FILE = "image_switch_boards.sql"
MEDIA_FILE = "media.sql"
BUCKET = "atp"
PREFIX = "data/frstclan/shared"
SETTING = YAML::load(File.open("./config/settings.yml"))
CREATED_ON = Time.now.utc.db
RETRYMAXTIMES = 5

class CustomS3
  attr_accessor :prefix, :bucket, :retry
  S3 = YAML.load_file('./config/amazon_s3.yml')[ENVIRON].symbolize_keys
  OPTS = { :access => :public_read }
  
  def initialize(bucket,prefix,retry_times=3)
    connect2s3(S3)
    @bucket = bucket
    @prefix = prefix
    @retry = retry_times
  end
  
  def connect2s3(s3)
    Base.establish_connection!(
      :access_key_id     => s3[:access_key_id],
      :secret_access_key => s3[:secret_access_key],
      :server            => s3[:server],
      :port              => s3[:port],
      :use_ssl           => s3[:use_ssl]
    )
  end
    
  def copy(src,dest)
    file = @prefix + src
    retry_times = 0
    begin
      S3Object.copy(file, dest, @bucket)
    rescue OpenURI::HTTPError, AWS::S3::NoSuchKey => e
      logger.error "#{file} missing: #{e.message.strip}"
    rescue Errno::ECONNRESET => e
      connect2s3(S3)
      logger.error "#{file} Connection Died: #{e.message.strip} #{retry_times} time trying"
      retry_times += 1
      retry if retry_times <= @retry
    rescue EOFError => e
      logger.error "WTF EOF Error (#{e.message.strip})"
    end
  end
end

class Split
  def initialize(medid=0)
    @@medium_id = medid
    @@imgswitch_file = ""
    @@media_file = ""
    #fire up logger
    sanitize(self)
  end
  
  def create_data_file
    return if File.exists?(DATAFILE)
    system "cat /dev/null > #{DATAFILE}"
    with_db do |db|
      res = db.query <<-SQL
      select images.url, images.name, image_sets.image_id, image_sets.id, images.user_id, image_sets.obj_id, image_sets.position, images.comments_allowed, images.caption from image_sets 
      LEFT OUTER JOIN images ON images.id = image_sets.image_id
      WHERE images.moved = 1
      ORDER BY image_sets.id desc
      SQL
      res.each do |r|
        open(IMAGEDATAFILE, 'a'){|f| f << "#{r.inspect}\n" }
      end
    end
  end
  
  def add_image_set(img)
    filename = "#{img[:name]}.jpg"
    @parent_img = img[:url] + filename
    #parent _image
    base_rec = {
      :content_type => "image/jpeg",
      :created_on => CREATED_ON,
      :size => 0,
      :type => "Photo",
      :obj_type => "Event",
      :obj_id => img[:set_obj_id],
      :thumbnail => nil,
      :user_id => img[:uid],
      :caption => Mysql.escape_string(img[:caption].to_s),
      :comments_allowed => img[:comments_allowed],
      :filename => filename,
      :height => 0,
      :parent_id => nil,
      :position => img[:position],
      :width => 0
    }
    parent_id = pop_media_table(base_rec)
    #child images
    ['small', 'large', 'tiny'].each do |size|
      filename2 = "#{img[:name]}_#{size}.jpg"
      @child_img = "#{img[:url]}#{filename2}"
      child_rec = base_rec.merge({
        :height => SETTING['image'][size]['height'],
        :width => SETTING['image'][size]['width'],
        :obj_type => nil,
        :obj_id => nil,
        :user_id => nil,
        :caption => nil,
        :position => nil,
        :thumbnail => size,
        :size => 0,
        :filename => filename2,
        :parent_id => @@medium_id
      })
      pop_media_table(child_rec)
    end
    #add to switchboard
    pop_image_switchboard(img[:id], img[:set_id])
  end
  
  def write2file(file,content)
    open(file, 'a'){|f| f << content }
  end
    
  private
  def sanitize(object)
    @@log = Logger.new(LOGFILE)
    def object.logger
      @logger ||= @@log
    end
    def object._logger
      @logger ||= @@log
    end
  end
  
  def logger(*args)
    self.logger(*args)
  end
  
  def with_db
    @db_conn = { :host => "localhost", :username => "root", :password => "", :database => "atp" }
    dbh = Mysql.real_connect(@db_conn[:host], @db_conn[:username], @db_conn[:password], @db_conn[:database])
    begin
      yield dbh 
    ensure
      dbh.close
    end
  end
  
  def pop_image_switchboard(image_id, image_set_id)
    write2file IMAGE_SWITCH_BOARDS_FILE, "INSERT INTO image_switch_boards(image_id, image_set_id, medium_id) VALUES (#{image_id}, #{image_set_id}, #{@@medium_id});\n"
  end
  
  def pop_media_table(rec)
    @@medium_id += 1
    rec = rec.prepare4db
    write2file MEDIA_FILE, "INSERT INTO media (id, content_type, created_on, size, thumbnail, obj_type, obj_id, updated_on, user_id, type, caption, comments_allowed, filename, height, parent_id, position, width) VALUES(#{@@medium_id}, #{rec[:content_type]}, #{rec[:created_on]}, #{rec[:size]}, #{rec[:thumbnail]}, #{rec[:obj_type]}, #{rec[:obj_id]}, now(), #{rec[:user_id]}, #{rec[:type]}, #{rec[:caption]}, #{rec[:comments_allowed]}, #{rec[:filename]}, #{rec[:height]}, #{rec[:parent_id]}, #{rec[:position]}, #{rec[:width]});\n"
  end
end

@current = Split.new
system "rm #{MEDIA_FILE} #{IMAGE_SWITCH_BOARDS_FILE}"
File.open(DATAFILE) do |lines|
  lines.each_line do |line|
    i = eval(line)
    image = {
      :url => i[0],
      :name => i[1],
      :id => i[2].to_i,
      :set_id => i[3].to_i,
      :uid => i[4].to_i,
      :set_obj_id => i[5].to_i,
      :position => i[6],
      :comments_allowed => i[7].to_i,
      :caption => i[8]
    }
    @current.add_image_set(image)
  end
end

# server :log => "output-#{DATAFILE}.sql" do |mr|
#   @counter = 0
#   @current.create_data_file
#   mr.type = File
#   mr.input = DATAFILE
#   mr.queue_size = 1000
#   mr.lines_per_client = 100
#   mr.rescan_when_complete = false
#   mr.medium_id = lambda { @counter += 1 }
# end
# 
# client do |lines|
#   lines.each_line do |line|
#     i = eval(line)
#     img = {
#       :url => i[0],
#       :name => i[1],
#       :id => i[2].to_i,
#       :set_id => i[3].to_i,
#       :uid => i[4].to_i,
#       :set_obj_id => i[5].to_i,
#       :position => i[6],
#       :comments_allowed => i[7].to_i,
#       :caption => i[8]
#     }
#     medium_id = server.medium_id.call
#     logger.info medium_id
#     @current.add_image_set(img,medium_id)
#   end
# end