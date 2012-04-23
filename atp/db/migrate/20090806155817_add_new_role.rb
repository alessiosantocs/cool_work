class AddNewRole < ActiveRecord::Migration
  def self.up
    r = Role.create :name => "Regional Rep", :active => true
    ["imagesnmyeye", "rmphoto", "davidpaulonline"].each do |username|
      if u = User.find_by_username(username)
        u.roles << r unless u.nil?
      end
    end
  end

  def self.down
    rep = Role.find_by_name("Regional Rep")
    rep.destroy
  end
end
