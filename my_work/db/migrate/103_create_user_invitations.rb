class CreateUserInvitations < ActiveRecord::Migration
  def self.up
    create_table :user_invitations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_invitations
  end
end
