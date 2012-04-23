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

IMAGEDATAFILE = "mv_imgset.txt"
BUCKET = "atp"
PREFIX = "data/frstclan/shared"
OPTS = { :access => :public_read }
S3 = YAML.load_file('./config/amazon_s3.yml')[ENVIRON].symbolize_keys
SETTING = YAML::load(File.open("./config/settings.yml"))
CREATED_ON = Time.now.utc.db
RETRYMAXTIMES = 5

Base.establish_connection!(
  :access_key_id     => S3[:access_key_id],
  :secret_access_key => S3[:secret_access_key],
  :server            => S3[:server],
  :port              => S3[:port],
  :use_ssl           => S3[:use_ssl]
)

class Verify
  def initialize
    @db_conn = { :host => "localhost", :username => "root", :password => "", :database => "atp" }
  end
  
  def create_data_file
    return if File.exists?(IMAGEDATAFILE)
    system "cat /dev/null > #{IMAGEDATAFILE}"
    # clear_table("media")
    # clear_table("image_switch_boards")
    with_db do |db|
      #url, name, id
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
    if image_exists?(img)
      logger.info "skipping id: #{img[:id]}"
      return nil
    else
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
      unless parent_id.nil?
        #copy image to new destination
        copy_s3_file(@parent_img, [base_rec[:type], parent_id, base_rec[:filename]].join("/"))
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
            :parent_id => parent_id
          })
          copy_s3_file(@child_img, [child_rec[:type], parent_id, child_rec[:filename]].join("/")) unless pop_media_table(child_rec).nil?
          #add to switchboard
        end  
        pop_image_switchboard(img[:id], img[:set_id], parent_id)
      end
    end
  end
  
  private
  def clear_table(table)
    with_db{|db| db.query "truncate #{table};" }
  end
  
  def image_exists?(img)
    retry_times = 0
    begin
      with_db do |db|
        res = db.query "select * from image_switch_boards WHERE image_id = #{img[:id]}"
        res.num_rows() > 0 ? true : false
      end
    rescue Mysql::Error => e
      retry_times += 1
      sleep(retry_times)
      retry if retry_times <= RETRYMAXTIMES
    end
  end
  
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
    file = PREFIX + src
    retry_times = 0
    begin
      S3Object.copy(file, dest, BUCKET)
    rescue OpenURI::HTTPError, AWS::S3::NoSuchKey => e
      logger.error "#{file} missing: #{e.message.strip} #{@image.inspect}"
    rescue EOFError, Errno::ECONNRESET => e
      logger.error "#{file} Connection Died: #{e.message.strip} #{@image.inspect}"
      retry_times += 1
      retry if retry_times <= RETRYMAXTIMES
    end
  end
end

@current = Verify.new

server :log => "zz#{IMAGEDATAFILE}.log" do |mr|
  @current.create_data_file
  mr.type = File
  mr.input = IMAGEDATAFILE
  mr.queue_size = 1500
  mr.lines_per_client = 100
  mr.rescan_when_complete = false
end

client do |lines|
  lines.each_line do |line|
    i = eval(line)
    @image = {
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
    @current.add_image_set(@image)
  end
end