namespace :test do

  task :coverage do
    FileUtils.rm_f "coverage"
    FileUtils.rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib -x test_rig.rb"
    system("#{rcov} --no-html test/unit/*_test.rb")
    system("#{rcov} --no-html test/functional/*_test.rb")
    system("#{rcov} --html test/integration/*_test.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end

end

namespace :db do
  
  namespace :sessions do
    
    desc "Purges sessions that haven’t been touched in the last month"
    task :clean => :environment do
      ActiveRecord::Base.connection.delete(
      "DELETE FROM sessions WHERE updated_at < now() - #{1.month}")
    end
    
    desc "Dumps the database-backed session data"
    task :dump => :environment do
      require 'pp'
      Dir["#{RAILS_ROOT}/app/models/**/*rb"].each{ |f| require f}
      sessions = CGI::Session::ActiveRecordStore::Session.find_all
      sessions.each do |session|
        pp session.data
      end
    end
    
    desc "Lookup session data by ID.  Set the environment variable ID=123"
    task :lookup => :environment do
      pp CGI::Session::ActiveRecordStore::Session.find_by_session_id(ENV['ID']).data
    end
  
  end
  
  desc "Prints the current schema version"
  task :schema_version => :environment do
    puts "Current version: " + ActiveRecord::Migrator.current_version.to_s
  end

end

desc "Print out all the currently defined routes, with names."
task :routes => :environment do
  name_col_width = ActionController::Routing::Routes.named_routes.routes.keys.sort {|a,b| a.to_s.size <=> b.to_s.size}.last.to_s.size
  ActionController::Routing::Routes.routes.each do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    name = name.ljust(name_col_width + 1)
    puts "#{name}#{route}"
  end
end

desc "freeze rails"
task :deploy_edge do
  ENV['SHARED_PATH']  = '../../shared' unless ENV['SHARED_PATH']
  ENV['RAILS_PATH'] ||= File.join(ENV['SHARED_PATH'], 'rails')
  ENV['REPO_BRANCH'] ||= 'trunk'
  
  checkout_path = File.join(ENV['RAILS_PATH'], 'trunk')
  export_path   = "#{ENV['RAILS_PATH']}/rev_#{ENV['REVISION']}"
  symlink_path  = 'vendor/rails'

  # do we need to checkout the file?
  unless File.exists?(checkout_path)
    puts 'setting up rails trunk'    
    get_framework_for checkout_path do |framework|
      system "svn co http://svn.rubyonrails.org/rails/#{ENV['REPO_BRANCH']}/#{framework}/lib #{checkout_path}/#{framework}/lib --quiet"
    end
  end

  # do we need to export the revision?
  unless File.exists?(export_path)
    puts "setting up rails rev #{ENV['REVISION']}"
    get_framework_for export_path do |framework|
      system "svn up #{checkout_path}/#{framework}/lib -r #{ENV['REVISION']} --quiet"
      system "svn export #{checkout_path}/#{framework}/lib #{export_path}/#{framework}/lib"
    end
  end

  puts 'linking rails'
  rm_rf   symlink_path
  mkdir_p symlink_path

  get_framework_for symlink_path do |framework|
    ln_s File.expand_path("#{export_path}/#{framework}/lib"), "#{symlink_path}/#{framework}/lib"
  end
  
  touch "vendor/rails_#{ENV['REVISION']}"
end

def get_framework_for(*paths)
  %w( railties actionpack activerecord actionmailer activesupport activeresource actionwebservice ).each do |framework|
    paths.each { |path| mkdir_p "#{path}/#{framework}" }
    yield framework
  end
end
