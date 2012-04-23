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
require "yaml"
require "lib/utils"
require 'aws/s3'
include AWS::S3
include Utils

IMAGEDATAFILE = "missing_imgs.log"
BUCKET = "atp"
OPTS = { :access => :public_read }
S3 = YAML.load_file('./config/amazon_s3.yml')[ENVIRON].symbolize_keys
SIZES = {
  :ad => ['flyer', 'banner_336x280'],
  :user => ['small', 'large', 'tiny'],
  :party => ['small', 'large', 'tiny'],
  :cover_image => ['cover_image'],
  :flyer => ['flyer', 'large']
}

Base.establish_connection!(
  :access_key_id     => S3[:access_key_id],
  :secret_access_key => S3[:secret_access_key],
  :server            => S3[:server],
  :port              => S3[:port],
  :use_ssl           => S3[:use_ssl]
)

def size(file)
  case file
    when /party/
      SIZES[:party]
    when /flyer/
      SIZES[:flyer]
    when /cover_image/
      SIZES[:cover_image]
    when /ad/
      SIZES[:ad]
    when /user/
      SIZES[:user]
  end
end

server :log => "#{IMAGEDATAFILE}.log" do |mr|
  mr.type = File
  mr.input = IMAGEDATAFILE
  mr.queue_size = 1000
  mr.lines_per_client = 100
  mr.rescan_when_complete = false
end

client do |lines|
  lines.each_line do |line|
    if line  =~ /id:\d+\sis\smissing/
      m =/\d+.+(data.+\.jpg)/.match(line)
      id = m[0].to_i
      file = m[1]
      if File.exists?("/#{file}")
        #S3Object.store("#{file}", open("/#{file}"), BUCKET, OPTS)
        size(file).each do |size|
          fsplit = file.split(".")
          path = fsplit[0] + "_#{size}.jpg"
          logger.debug "DEBUG: #{path}"
          begin
            if File.exists?("/#{path}")
              #S3Object.store("#{path}", open("/#{path}"), BUCKET, OPTS)
              logger.info  "skipping #{id}"
            else
              logger.error "id:#{id} is missing (#{path})"
            end
          rescue Exception => e
            logger.error "ERROR: #{id} | #{e.message.strip}"
          end
        end
      else
        logger.error "id:#{id} is missing (#{file})"
      end
    end
  end
end