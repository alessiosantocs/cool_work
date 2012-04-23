class AddAdminRole < ActiveRecord::Migration
  def self.up
    admin_role = Role.create(:name => 'admin')
    
    users = User.find(:all)
    for user in users
      if ['admin'].include? user.user_class
        user.roles << admin_role
        user.save!
      end
    end
  end
  
  def self.down
  end
end
