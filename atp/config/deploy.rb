task :uname, :roles => :app do
  run "uname -a"
end

# =============================================================================
# TASKS

task :after_update_code, :roles => :app, :except => {:no_symlink => true} do
  run <<-CMD
    cd #{release_path} &&
    ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
    ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml
  CMD
end

desc "Clone Production Database to Staging Database."
task :clonedb_prod_to_stage, :roles => :db, :only => { :primary => true } do
  now = Time.now
  backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
  backup_file = "/data/#{user}/shared/production-snapshot-#{backup_time}.sql"
  compressed_file = "/data/#{user}/shared/pro.tar.gz"
  on_rollback { delete backup_file }
  run "rm -f /data/#{user}/shared/production-snapshot-*.sql"
  run "rm -f #{compressed_file}"
  
  run "mysqldump --add-drop-table -u #{mysql_user_prod} -h mysql50-4 -p #{production_database} > #{backup_file}" do |ch, stream, out|
    ch.send_data mysql_pass_prod+"\n" if out =~ /Enter password:/
  end
  
  run "mysql -u #{mysql_user_stage} -p -h mysql #{stage_database} < #{backup_file}" do |ch, stream, out|
    ch.send_data mysql_pass_stage+"\n" if out =~ /Enter password:/
  end
  
  run "tar zcvf #{compressed_file} #{backup_file}"
end

task :after_deploy, :roles => :app, :except => {:no_symlink => true} do
  run "rm -rf #{deploy_to}/current/tmp/cache/*"
  "deploy:cleanup"
end  

# uncomment if you use edge rails so we can cache a copy of
# rails on your slice and then just symlink it in after deploy.
#task :after_symlink, :roles => :app , :except => {:no_symlink => true} do
#  run "ln -nfs #{shared_path}/rails #{release_path}/rails" 
#end  


# custom Engine Yard tasks. Don't change unless you know
# what you are doing!

desc <<-DESC
Restart the Mongrel processes on the app server by calling restart_mongrel_cluster.
DESC
task :restart, :roles => :app do
  restart_mongrel_cluster
end

desc <<-DESC
Start the Mongrel processes on the app server by calling start_mongrel_cluster.
DESC
task :spinner, :roles => :app do
  start_mongrel_cluster
end

desc <<-DESC
Start Mongrel processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
set to true.
DESC
task :start_mongrel_cluster , :roles => :app do
  sudo "/etc/init.d/mongrel_cluster start"
end

desc <<-DESC
Restart the Mongrel processes on the app server by starting and stopping the cluster. This uses the :use_sudo
variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
DESC
task :restart_mongrel_cluster , :roles => :app do
  sudo "/etc/init.d/mongrel_cluster restart"
end

desc <<-DESC
Stop the Mongrel processes on the app server.  This uses the :use_sudo
variable to determine whether to use sudo or not. By default, :use_sudo is
set to true.
DESC
task :stop_mongrel_cluster , :roles => :app do
  sudo "/etc/init.d/mongrel_cluster stop"
end

desc <<-DESC
Start Nginx on the app server.
DESC
task :start_nginx, :roles => :app do
  sudo "/etc/init.d/nginx start"
end

desc <<-DESC
Restart the Nginx processes on the app server by starting and stopping the cluster.
DESC
task :restart_nginx , :roles => :app do
  sudo "/etc/init.d/nginx restart"
end

desc <<-DESC
Stop the Nginx processes on the app server. 
DESC
task :stop_nginx , :roles => :app do
  sudo "/etc/init.d/nginx stop"
end

# desc <<-DESC
# Install RubyGems
# DESC
# task :install_gems do
#   gem.select 'tzinfo'
#   gem.select 'ferret'
# end