set :application, "myonlinecleaner.com"
set :rails_env, 'production'

set :branch, 'master'

role :app, '64.6.232.251'
role :web, '64.6.232.251'
role :db, '64.6.232.251', :primary => true

after 'deploy:update_code', 'deploy:symlinks'
