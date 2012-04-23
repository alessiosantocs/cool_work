# = E2 Rake - Turn ec2 commands into rake tasks
#
# Author::    Steve Odom
# License::   GPL

require 'yaml'
require 'erb'

namespace :ec2 do
  @ec2_config ||= YAML::load(ERB.new(IO.read("#{RAILS_ROOT}/config/aws.yml")).result)
  
  desc <<-DESC
  Describe the available images to launch. To get public images too add id=--all to your request.
  Example: rake ec2:images id=--all
  DESC
  task :images do
    p ||= ENV['id'] 
    bash "cd #{ENV['EC2_HOME']}bin && ./ec2-describe-images #{p}"
  end
  
  desc <<-DESC
  "Run an image. You must first get the ami id by running 'rake ec2:images.'
  Example - rake ec2:run id=ami-61a54008
  DESC
  task :run do
    begin
      bash "cd #{ENV['EC2_HOME']}bin && ./ec2-run-instances #{ENV['id']} -k #{@ec2_config['ec2_keypair_name']}"
    rescue
      puts "You need to pass in the ami id. Example - rake ec2:run id=ami-61a54008"
    end
  end
  
  desc "Describe instances that are currently running"
  task :instances do
    bash "cd #{ENV['EC2_HOME']}bin && ./ec2-describe-instances"
  end
  
  desc "Copy Keys to EC2 Server"
  task :copy_keys do
    bash "scp -i #{@ec2_config['keypair_name']} #{ENV['EC2_PRIVATE_KEY']} #{ENV['EC2_CERT']} root@#{@ec2_config['url']}:/tmp"
  end
  
  desc "Use Capistrano to bundle my image"
  task :bundle_instance => [ "copy_keys" ] do
    bash "cap bundle_instance"
  end
  
  desc "Use Capistrano to upload my image to s3"
  task :upload_image do
    bash "cap upload_image"
  end
  
  desc "Register the image at ec2"
  task :register do
    bash "cd #{ENV['EC2_HOME']}bin && ./ec2-register #{@ec2_config['image_bucket']}/#{get_timestamp}.manifest.xml"
  end
  
  desc "Bundle and upload the image to s3"
  task :complete_bundle => [ "bundle_instance", "upload_image", "register" ] do
    puts "Enjoy your new instance"
  end
  
  desc <<-DESC
  "Terminate an instance. You must first get the id by running 'rake ec2:instances.'
  Example - rake ec2:terminate id=ami-61a54008
  DESC
  task :terminate do
    begin
      bash "cd #{ENV['EC2_HOME']}bin && ./ec2-terminate-instances #{ENV['id']}"
    rescue
      puts "You need to pass in the instance id. Example - rake ec2:terminate id=i-fc678395"
    end
  end
  
  desc <<-DESC
  Login to our EC2 instance. You can pass in the username with id=username
  Example - rake ec2:login id=shopguy
  DESC
  task :login do
    usr = (ENV['id'])? ENV['id'] : 'root'
    bash "ssh -i #{@ec2_config['keypair_name']} #{usr}@#{@ec2_config['url']}"
  end
  
  desc <<-DESC
  This doesn't work. I'll have to figure out how to add a user and sudoer him.
  DESC
  task :patch_raw do
    #login to the server and add the primary user
    bash "ssh -i #{@ec2_config['keypair_name']} root@#{@ec2_config['url']} 'groupadd www && useradd -g www deploy && passwd deploy'"
    bash "cap patch_raw"
  end
end

private
def bash(cmd)
  puts(cmd) 
  system(cmd)
end

# this matches code in config/deploy.rb. Each image is named with this time_stamp
# I'm sure there is better way to do this. It will break if the time between bundling
# the image is greater than one day. Or if two images are bundled in the same day.
def get_timestamp
  Time.now.utc.strftime("%b%d%Y")
end