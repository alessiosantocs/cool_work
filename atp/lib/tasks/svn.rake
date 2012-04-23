namespace :svn do
  desc "Add new files to subversion"
  task :add_new_files do
     system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
  end
  
  desc "shortcut for adding new files"
  task :add => [ :add_new_files  ]
end