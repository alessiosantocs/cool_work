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

require "rubygems"
require 'mysql'
require "yaml"
require 'find'
require 'logger'
require "mini_magick"
require "lib/utils"
include Utils
require 'aws/s3'
include AWS::S3

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

SETTING = YAML::load(File.open("./config/settings.yml"))
S3 = YAML.load_file('./config/amazon_s3.yml')[ENVIRON].symbolize_keys
S3_PREFIX = "data/frstclan/shared"

LOGFILE = "#{ROOT}/log/moveimgstos3.log"
CREATED_ON = Time.now.utc.db

class Mysql
  alias :query_no_block :query
  def query(sql)
    res = query_no_block(sql)
    return res unless block_given?
    begin
      yield res
    ensure
      res.free if res
    end
  end
end

class MoveImgsToS3
  attr_reader :db_conn
  def initialize
    @db_conn = { :host => "localhost", :username => "root", :password => "", :database => "atp" }
    #fire up logger
    sanitize(self)
    
    #connect to s3
    Base.establish_connection!(
      :access_key_id     => S3[:access_key_id],
      :secret_access_key => S3[:secret_access_key],
      :server            => S3[:server],
      :port              => S3[:port],
      :use_ssl           => S3[:use_ssl]
    )
    @bucket = "atp"
    set_db(DB)
  end
  
  def pop_image_switchboard(image_id, image_set_id, medium_id)
    insertRecord "INSERT INTO image_switch_boards(image_id, image_set_id, medium_id) VALUES (#{image_id}, #{image_set_id}, #{medium_id});"
  end
  
  def pop_media_table(rec)
    rec = rec.prepare4db
    medium_id = nil
    sql = <<-SQL
    INSERT INTO media (content_type, created_on, size, thumbnail, obj_type, obj_id, updated_on, user_id, type, caption, comments_allowed, filename, height, parent_id, position, width) 
    VALUES(#{rec[:content_type]}, #{rec[:created_on]}, #{rec[:size]}, #{rec[:thumbnail]}, #{rec[:obj_type]}, #{rec[:obj_id]}, now(), 
    #{rec[:user_id]}, #{rec[:type]}, #{rec[:caption]}, #{rec[:comments_allowed]}, #{rec[:filename]}, 
    #{rec[:height]}, #{rec[:parent_id]}, #{rec[:position]}, #{rec[:width]});
    SQL
    begin
      medium_id = insertRecord sql
      logger.info "Media Id #{medium_id} created."
    rescue Mysql::Error => e
      logger.error "\n#{e}\n#{sql}\n"
    end
    medium_id
  end
  
  def flyers
    #all flyers created today
    with_db do |db|
      res = db.query <<-SQL
      select flyers.id as flyer_id, flyers.obj_type as flyer_obj_type, flyers.obj_id as flyer_obj_id, images.url, images.name, images.user_id from flyers 
      LEFT OUTER JOIN images ON images.id = flyers.image_id
      SQL
      res.each do |r|
        logger.info "Doing Flyer ##{r.inspect}"
        #find flyer on s3
        filename = "#{r[4]}#{SETTING['image_server']['extension']}"
        parent_img = "#{r[3]}#{filename}"
        on_s3 = find_s3_file(parent_img)
        if on_s3.is_a?(AWS::S3::S3Object)
          #parent _image
          base_rec = {
            :content_type => "image/jpeg",
            :created_on => CREATED_ON,
            :size => on_s3.about["content-length"],
            :type => "#{r[1]}Flyer",
            :obj_type => "#{r[1]}",
            :obj_id => "#{r[2]}",
            :thumbnail => nil,
            :user_id => r[5],
            :caption => "",
            :comments_allowed => 0,
            :filename => filename,
            :height => 0,
            :parent_id => nil,
            :position => nil,
            :width => 0
          }
          parent_id = pop_media_table(base_rec)
          unless parent_id.nil?
            #copy image to new destination
            copy_s3_file(parent_img, [base_rec[:type], parent_id, base_rec[:filename]].join("/"))
            #child images
            get_img_sizes("Flyer").each do |size|
              filename2 = "#{r[4]}_#{size}#{SETTING['image_server']['extension']}"
              child_img = "#{r[3]}#{filename2}"
              on_s3_2 = find_s3_file(child_img)
              if on_s3_2.is_a?(AWS::S3::S3Object)
                child_rec = base_rec.merge({
                  :height => SETTING['image'][size]['height'],
                  :position => nil,
                  :width => SETTING['image'][size]['width'],
                  :obj_type => nil,
                  :obj_id => nil,
                  :thumbnail => size,
                  :size => on_s3.about["content-length"],
                  :user_id => nil,
                  :filename => filename2,
                  :parent_id => parent_id
                })
                copy_s3_file(child_img, [child_rec[:type], child_rec[:parent_id], child_rec[:filename]].join("/")) unless pop_media_table(child_rec).nil?
              else
                logger.error "#{size}/#{parent_id} is missing"
              end
            end
          else
            
          end
        end
      end
    end
  end
  
  def cover_images
    #all cover image created today
    with_db do |db|
      res = db.query <<-SQL
      select cover_images.id, cover_images.image_id, images.url, images.name, images.user_id from cover_images 
      LEFT OUTER JOIN images ON images.id = cover_images.image_id
      SQL
      res.each do |r|
        logger.info "Doing Cover ##{r.inspect}"
        #find cover image on s3
        filename = "#{r[3]}.jpg"
        parent_img = "#{r[2]}#{filename}"
        on_s3 = find_s3_file(parent_img)
        if on_s3.is_a?(AWS::S3::S3Object)
          #parent _image
          base_rec = {
            :content_type => "image/jpeg",
            :created_on => CREATED_ON,
            :size => on_s3.about["content-length"],
            :type => "Cover",
            :obj_type => nil,
            :obj_id => nil,
            :thumbnail => nil,
            :user_id => r[4],
            :caption => nil,
            :comments_allowed => 0,
            :filename => filename,
            :height => 0,
            :parent_id => nil,
            :position => 1,
            :width => 0
          }
          parent_id = pop_media_table(base_rec)
          unless parent_id.nil?
            #copy image to new destination
            copy_s3_file(parent_img, [base_rec[:type], parent_id, base_rec[:filename]].join("/"))
            #child images
            get_img_sizes("CoverImage").each do |size|
              filename2 = "#{r[3]}_#{size}#{SETTING['image_server']['extension']}"
              child_img = "#{r[2]}#{filename2}"
              on_s3_2 = find_s3_file(child_img)
              if on_s3_2.is_a?(AWS::S3::S3Object)
                child_rec = base_rec.merge({
                  :height => SETTING['image'][size]['height'],
                  :position => nil,
                  :width => SETTING['image'][size]['width'],
                  :obj_type => nil,
                  :obj_id => nil,
                  :thumbnail => size,
                  :size => on_s3.about["content-length"],
                  :user_id => nil,
                  :filename => filename2,
                  :parent_id => parent_id
                })
                copy_s3_file(child_img, [child_rec[:type], child_rec[:parent_id], child_rec[:filename]].join("/")) unless pop_media_table(child_rec).nil?
              else
                logger.error "#{size}/#{parent_id} is missing"
              end
            end
          end
        end
      end
    end
  end
  
  def ads
    with_db do |db|
      res = db.query <<-SQL
      select ads.id, ads.image_id, images.url, images.name, images.user_id from ads 
      LEFT OUTER JOIN images ON images.id = ads.image_id
      limit 1
      SQL
      res.each do |r|
        logger.info "Doing Ads ##{r.inspect}"
        #find ads on s3
        filename = "#{r[3]}#{SETTING['image_server']['extension']}"
        parent_img = "#{r[2]}#{filename}"
        on_s3 = find_s3_file(parent_img)
        if on_s3.is_a?(AWS::S3::S3Object)
          #parent _image
          base_rec = {
            :content_type => "image/jpeg",
            :created_on => CREATED_ON,
            :size => on_s3.about["content-length"],
            :type => "AdImage",
            :obj_type => nil,
            :obj_id => nil,
            :thumbnail => nil,
            :user_id => r[4],
            :caption => nil,
            :comments_allowed => 0,
            :filename => filename,
            :height => 0,
            :parent_id => nil,
            :position => 1,
            :width => 0
          }
          parent_id = pop_media_table(base_rec)
          unless parent_id.nil?
            #copy image to new destination
            copy_s3_file(parent_img, [base_rec[:type], parent_id, base_rec[:filename]].join("/"))
            #child images
            get_img_sizes("Ad").each do |size|
              filename2 = "#{r[3]}_#{size}#{SETTING['image_server']['extension']}"
              child_img = "#{r[2]}#{filename2}"
              on_s3_2 = find_s3_file(child_img)
              if on_s3_2.is_a?(AWS::S3::S3Object)
                child_rec = base_rec.merge({
                  :height => SETTING['image'][size]['height'],
                  :position => nil,
                  :width => SETTING['image'][size]['width'],
                  :obj_type => nil,
                  :obj_id => nil,
                  :thumbnail => size,
                  :size => on_s3.about["content-length"],
                  :user_id => nil,
                  :filename => filename2,
                  :parent_id => parent_id
                })
                copy_s3_file(child_img, [child_rec[:type], child_rec[:parent_id], child_rec[:filename]].join("/")) unless pop_media_table(child_rec).nil?
              else
                logger.error "#{size}/#{parent_id} is missing"
              end
            end
          end
        end
      end
    end
  end
  
  def image_sets
    with_db do |db|
      res = db.query <<-SQL
      select image_sets.id, image_sets.image_id, images.url, images.name, images.user_id, image_sets.obj_id, image_sets.position from image_sets 
      LEFT OUTER JOIN images ON images.id = image_sets.image_id
      ORDER BY image_sets.id desc
      SQL
      res.each do |r|
        logger.info "Doing ImageSet ##{r.inspect}"
        #find image sets on s3
        filename = "#{r[3]}#{SETTING['image_server']['extension']}"
        parent_img = "#{r[2]}#{filename}"
        on_s3 = find_s3_file(parent_img)
        if on_s3.is_a?(AWS::S3::S3Object)
          #parent _image
          base_rec = {
            :content_type => "image/jpeg",
            :created_on => CREATED_ON,
            :size => on_s3.about["content-length"],
            :type => "Photo",
            :obj_type => "Event",
            :obj_id => r[5],
            :thumbnail => nil,
            :user_id => r[4],
            :caption => nil,
            :comments_allowed => 0,
            :filename => filename,
            :height => 0,
            :parent_id => nil,
            :position => r[6],
            :width => 0
          }
          parent_id = pop_media_table(base_rec)
          unless parent_id.nil?
            #add to switchboard
            pop_image_switchboard(r[1], r[0], parent_id)
            #copy image to new destination
            copy_s3_file(parent_img, [base_rec[:type], parent_id, base_rec[:filename]].join("/"))
            #child images
            get_img_sizes("Event").each do |size|
              filename2 = "#{r[3]}_#{size}#{SETTING['image_server']['extension']}"
              child_img = "#{r[2]}#{filename2}"
              on_s3_2 = find_s3_file(child_img)
              if on_s3_2.is_a?(AWS::S3::S3Object)
                child_rec = base_rec.merge({
                  :height => SETTING['image'][size]['height'],
                  :width => SETTING['image'][size]['width'],
                  :obj_type => nil,
                  :obj_id => nil,
                  :user_id => nil,
                  :position => nil,
                  :thumbnail => size,
                  :size => on_s3.about["content-length"],
                  :filename => filename2,
                  :parent_id => parent_id
                })
                copy_s3_file(child_img, [child_rec[:type], child_rec[:parent_id], child_rec[:filename]].join("/")) unless pop_media_table(child_rec).nil?
              else
                logger.info "#{size}/#{parent_id} is missing"
              end
            end
          end
        end
      end
    end
  end
  
  def clear_table(table)
    #with_db{|db| db.query "truncate #{table};" }
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
  
  def get_img_sizes(type)
    case type
		  when 'Ad'
		    ['flyer', 'banner_336x280']
		  when 'User'
		    ['small', 'large', 'tiny']
		  when 'Event'
		    ['small', 'large', 'tiny']
		  when 'CoverImage'
		    ['cover_image']
		  when 'Flyer'
		    ['flyer', 'large']
		  else
		    []
		end
  end
  
  def copy_s3_file(src,dest)
    S3Object.copy("#{S3_PREFIX}#{src}", dest, @bucket)
  end

  def find_s3_file(full_path)
    path = "#{S3_PREFIX}#{full_path}"
    r = nil
    begin
      r = S3Object.find(path, @bucket)
    rescue AWS::S3::NoSuchKey => e
      logger.error "Missing #{path}"
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
  
  def with_db
    dbh = Mysql.real_connect(@db_conn[:host], @db_conn[:username], @db_conn[:password], @db_conn[:database])
    begin
      yield dbh 
    ensure
      dbh.close
    end
  end

  def set_db(opt={})
    @db_conn = { :host => "mysql", :username => "frstclan_stage", :password => "ODaYZPCqojCq", :database => "frstclan_stage" }.merge(opt)
  end
end

move = MoveImgsToS3.new()
move.cover_images
move.ads
move.flyers
#move.image_sets