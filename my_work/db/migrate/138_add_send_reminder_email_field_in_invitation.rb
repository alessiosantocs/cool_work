class AddSendReminderEmailFieldInInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :send_reminder_email, :boolean, :default => false
  end

  def self.down
    remove_column :invitations, :send_reminder_email
  end
end
