class MinorUpdatesForUserAndRole < ActiveRecord::Migration
  def self.up
    remove_column "roles_users", "created_on"
    add_index "users", ["created_on", "deleted", "allow_admin_mails", "email_messages_allowed"], :name => "idx_mailing_list", :unique => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
