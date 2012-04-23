class AddInvitationmaxToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_max, :integer
  end

  def self.down
    remove_column :users, :invitation_max
  end
end
