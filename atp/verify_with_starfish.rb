class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[key.to_sym] = value
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

IMAGEDATAFILE = "images_data.txt"
BUCKET = "atp"
PREFIX = "data/frstclan/shared"
OPTS = { :access => :public_read }
S3 = YAML.load_file('./config/amazon_s3.yml')[ENVIRON].symbolize_keys

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
    @sizes = {
      :ad => ['flyer', 'banner_336x280'],
      :user => ['small', 'large', 'tiny'],
      :party => ['small', 'large', 'tiny'],
      :cover_image => ['cover_image'],
      :flyer => ['flyer', 'large']
    }
  end
  
  def moved(id)
    with_db{|db| db.query("update images SET moved=1 where id=#{id};") }
  end
  
  def create_data_file
    return if File.exists?(IMAGEDATAFILE)
    system "cat /dev/null > #{IMAGEDATAFILE}"
    with_db do |db|
      res = db.query("select url, name, id from images where moved is NULL;")
      res.each do |r|
        open(IMAGEDATAFILE, 'a'){ |f| f << "#{r[2]},#{r[0]}#{r[1]}.jpg\n" }
      end
    end
  end
  
  def save2s3(id,path)
    #S3Object.store("#{path}", open("/#{path}"), BUCKET, OPTS)
    logger.info "Move: #{id}: /#{path}"
  end

  def find_s3_file(id,full_path)
    path = PREFIX + full_path
    if S3Object.exists?(path, BUCKET)
      logger.info "Skipping #{id}"
      true
    else
      begin
        if File.exists?("/#{path}")
          save2s3(id,path) #original
          type = full_path.split('/')[2].to_sym
          @sizes[type].each do |size|
            fsplit = path.split(".")
            save2s3(id,fsplit[0] + "_#{size}.jpg")
          end
          true
        else
          logger.error "id:#{id} is missing (#{path})"
          false
        end
      rescue Exception => e
        logger.error "ERROR: #{id} | #{e.message.strip}"
        false
      end
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
end

@current = Verify.new

server :log => "zz#{IMAGEDATAFILE}.log" do |mr|
  @current.create_data_file
  mr.type = File
  mr.input = IMAGEDATAFILE
  mr.queue_size = 2000
  mr.lines_per_client = 100
  mr.rescan_when_complete = false
end

client do |lines|
  lines.each_line do |line|
    id,filename = line.strip.split(',')
    @current.moved(id) if @current.find_s3_file(id,filename)
  end
end