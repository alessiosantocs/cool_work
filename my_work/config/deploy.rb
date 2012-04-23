after 'deploy:update_code', 'deploy:symlinks'
require 'capistrano/ext/multistage'

set :stages, [:staging, :production]
#set :autotagger_stages, [:production]
set :default_stage, :staging

set :user, "root"
set :use_sudo, false
set (:deploy_to) {"/var/www/#{application}"}
# use export for staging, remote_cache for production
# set :deploy_via, :remote_cache

default_run_options[:pty] = true
set :repository,  "git@github.com:esdutton/myonlinecleaner_new.git"
set :scm, :git



# Thinking Sphinx typing shortcuts
namespace :deploy do

  desc "Restarting mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
#     run "touch #{current_path}/tmp/restart.txt"
    run "cd #{current_path}; mongrel_rails cluster::stop "
    run "cd #{current_path}; mongrel_rails cluster::start "
  end

#   desc "Restarting mongrel "
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "cd #{current_path}; mongrel_rails cluster::stop "    
#     run "cd #{current_path}; mongrel_rails cluster::start"
#   end

  task :symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#     run "ln -nfs #{shared_path}/config/certs #{release_path}/config/certs"
#     run "ln -nfs #{shared_path}/product_images #{release_path}/public/product_images"
#     run "ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml"
  end
end




############ old code ####################################

# set :repository, "git@github.com:esdutton/myonlinecleaner_new.git"
# # set :svn_user, "devwdec"
# # set :svn_password, "Rails4dev"
#   
# set :application, "staging"
# set :domain, "74.86.27.152"
# set :user, "devwdec"
# set :password, "Rails4dev"
# set :use_sudo, false
# 
# set :deploy_to, "/home/#{user}/#{application}"
# set :deploy_via, :export
# set :chmod755, "app config db lib public vendor script script/* public/disp*"
# set :mongrel_port, "4228"
# set :mongrel_nodes, "2"
# 
# default_run_options[:pty] = true
# # Cap won't work on windows without the above line, see
# # http://groups.google.com/group/capistrano/browse_thread/thread/13b029f75b61c09d
# # Its OK to leave it true for Linux/Mac
# 
# # ssh_options[:keys] = %w(/Path/To/id_rsa)
# 
# role :app, domain
# role :web, domain
# role :db,  domain, :primary => true



