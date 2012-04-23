class AddInvitationcountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_count, :integer
  end

  def self.down
    remove_column :users, :invitation_count
  end
end
