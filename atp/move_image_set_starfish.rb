class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[key.to_sym] = value
      options
    end
  end
  
  def prepare4db
    inject({}) do |options, (key, value)|
      options[key] = (value.nil? ? 'NULL' : "'#{value}'")
      options
    end
  end
end

if File.directory? '/data/frstclan/current'
  ROOT = "/data/frstclan/current"
  ENVIRON = "production"
  DB = {}
elsif File.directory? "/Users/onyekwelu/workspace/atp/trunk"
  ROOT = "/Users/onyekwelu/workspace/atp/trunk"
  ENVIRON = "development"
  DB = {
    :adapter => "mysql",
    :host => "localhost",
    :username => "root",
    :password => "",
    :database => "atp_dev"
  }
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

IMAGEDATAFILE = "img_mig.txt"
BUCKET = "atp"
PREFIX = "data/frstclan/shared"
OPTS = { :access => :public_read }
S3 = YAML.load_file('./config/amazon_s3.yml')[ENVIRON].symbolize_keys
SETTING = YAML::load(File.open("./config/settings.yml"))

CREATED_ON = Time.now.utc.db

Base.establish_connection!(
  :access_key_id     => S3[:access_key_id],
  :secret_access_key => S3[:secret_access_key],
  :server            => S3[:server],
  :port              => S3[:port],
  :use_ssl           => S3[:use_ssl]
)

class Move
  def initialize
    @db_conn = { :host => "mysql", :username => "frstclan_stage", :password => "ODaYZPCqojCq", :database => "frstclan_stage" }.merge(DB)
  end
  
  def moved(id)
    with_db{|db| db.query("update images SET moved=1 where id=#{id};") }
  end
  
  def create_data_file
    return if File.exists?(IMAGEDATAFILE)
    system "cat /dev/null > #{IMAGEDATAFILE}"
    with_db do |db|
      res = db.query("select url, name, id from image_sets;")
      res.each do |r|
        open(IMAGEDATAFILE, 'a'){ |f| f << "#{r[2]},#{r[0]}#{r[1]}.jpg\n" }
      end
    end
  end
  
  def add_image_set(imgset)
    img = imgset.image
    return unless img.moved === true
    filename = "#{img.name}.jpg"
    @parent_img = "#{img.url}#{filename}"
    #parent _image
    begin
      base_rec = {
        :content_type => "image/jpeg",
        :created_on => CREATED_ON,
        :size => File.size("/#{PREFIX}#{@parent_img}"),
        :type => "Photo",
        :obj_type => "Event",
        :obj_id => imgset.obj_id,
        :thumbnail => nil,
        :user_id => img.user_id,
        :caption => img.caption,
        :comments_allowed => img.comments_allowed,
        :filename => filename,
        :height => 0,
        :parent_id => nil,
        :position => imgset.position,
        :width => 0
      }
    rescue Errno::ENOENT => e
      logger.error "imgid:#{img.id} | #{e.message.strip}"
      return nil
    end
    
    parent_id = pop_media_table(base_rec)
    unless parent_id.nil?
      #copy image to new destination
      copy_s3_file(@parent_img, [base_rec[:type], parent_id, base_rec[:filename]].join("/"))
      #child images
      ['small', 'large', 'tiny'].each do |size|
        filename2 = "#{img.name}_#{size}.jpg"
        @child_img = "#{img.url}#{filename2}"
        child_rec = base_rec.merge({
          :height => SETTING['image'][size]['height'],
          :width => SETTING['image'][size]['width'],
          :obj_type => nil,
          :obj_id => nil,
          :user_id => nil,
          :position => nil,
          :thumbnail => size,
          :size => File.size("/#{PREFIX}#{@child_img}"),
          :filename => filename2,
          :parent_id => parent_id
        })
        copy_s3_file(@child_img, [child_rec[:type], child_rec[:parent_id], child_rec[:filename]].join("/")) unless pop_media_table(child_rec).nil?
        #add to switchboard
      end  
      pop_image_switchboard(img.id, imgset.id, parent_id)
    end
  end
  
  private
  def with_db
    dbh = Mysql.real_connect(@db_conn[:host], @db_conn[:username], @db_conn[:password], @db_conn[:database])
    begin
      yield dbh 
    ensure
      dbh.close
    end
  end
  
  def insertRecord(stmt)
    res = nil
    with_db do |db|
      res = db.prepare(stmt)
      res.execute
    end
    res.insert_id()
  end
  
  def pop_image_switchboard(image_id, image_set_id, medium_id)
    insertRecord "INSERT INTO image_switch_boards(image_id, image_set_id, medium_id) VALUES (#{image_id}, #{image_set_id}, #{medium_id});"
  end
  
  def pop_media_table(rec)
    rec = rec.prepare4db
    sql = <<-SQL
    INSERT INTO media (content_type, created_on, size, thumbnail, obj_type, obj_id, updated_on, user_id, type, caption, comments_allowed, filename, height, parent_id, position, width) 
    VALUES(#{rec[:content_type]}, #{rec[:created_on]}, #{rec[:size]}, #{rec[:thumbnail]}, #{rec[:obj_type]}, #{rec[:obj_id]}, now(), 
    #{rec[:user_id]}, #{rec[:type]}, #{rec[:caption]}, #{rec[:comments_allowed]}, #{rec[:filename]}, 
    #{rec[:height]}, #{rec[:parent_id]}, #{rec[:position]}, #{rec[:width]});
    SQL
    begin
      medium_id = insertRecord sql
      logger.info "mid:#{medium_id}"
      return medium_id
    rescue Mysql::Error => e
      logger.error "mid not created: #{e.message.strip}"
      return nil
    end
  end
  
  def copy_s3_file(src,dest)
    begin
      S3Object.copy(PREFIX + src, dest, BUCKET)
    rescue OpenURI::HTTPError => e
      logger.error "#{PREFIX + src} missing: #{e.message.strip}"
    end
  end
end

@current = Move.new
server :log => "ll#{IMAGEDATAFILE}.log" do |mr|
  @current.create_data_file
  mr.type = File
  mr.input = IMAGEDATAFILE
  mr.queue_size = 2500
  mr.lines_per_client = 500
  mr.rescan_when_complete = false
end

client do |lines|
  lines.each_line do |line|
    id,filename = line.strip.split(',')
    @current.moved(id) if @current.find_s3_file(id,filename)
  end
end