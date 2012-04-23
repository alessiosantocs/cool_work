class AddAccessRoles < ActiveRecord::Migration
  def self.up
    Role.create(:name => 'accounts')
    Role.create(:name => 'intake')
    Role.create(:name => 'scheduling')
    Role.create(:name => 'sort')
    Role.create(:name => 'deliver')
    Role.create(:name => 'content')
  end

  def self.down
  end
end
