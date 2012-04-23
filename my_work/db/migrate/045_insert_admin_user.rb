class InsertAdminUser < ActiveRecord::Migration
  def self.up
    #u = User.new(:login => 'admin', :password => 'admin', :user_class => 'admin', :email => 'admin@wdezine.com', :password_confirmation => 'admin')
    #u.save!
  end
  
  def self.down
    #User.find(:first, :conditions => [ "login = 'admin'"]).destroy
  end
end
